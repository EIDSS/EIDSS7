
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/1/2017
-- Last modified by:		Joan Li
-- Description:				Created a new SP to convert inline SQL code in EIDSS app in v6 USP24 v7
--                          Input: language ID; Output: N/A  
--                          5/1/2017: get rid of duplicated columns with the same name
--                          7/19/2017: add input paramter to return two different lists
-- Testing code:
/*
DECLARE	@return_value int
EXEC	@return_value = [dbo].[usp_OrganizationGetList]
		@LangID ='en' ---- ' ' ----NULL ----N'ru'
execute usp_OrganizationGetList 'en'
execute usp_OrganizationGetList 'en','ALL'
----select * from tlboffice
select * from fninstitution('en')
select * from tlbGeoLocationShared 
*/

--=====================================================================================================
CREATE  procedure [dbo].[usp_OrganizationGetList]
(
@LangID  nvarchar(50)='en'  ----v6 function code with this default value
,@listWhat varchar(10) =NULL ----V7 added for showing two list option
)
as

BEGIN
		declare @l_langid nvarchar(50)
		IF @LangID is null
			RAISERROR (15600,-1,-1, 'usp_OrganizationGetList'); 
		ELSE if @LangID=''
			RAISERROR (15600,-1,-1, 'usp_OrganizationGetList');
		ELSE
			SELECT @l_langid=@LangID
			IF @listWhat IS NULL 
					BEGIN

						select 
      					   fn_organization_selectlist.idfInstitution
      					   ,fn_organization_selectlist.FullName
      					   ,fn_organization_selectlist.name
      					   ,fn_organization_selectlist.Address
      					   ,fn_organization_selectlist.intHACode
      					   ,fn_organization_selectlist.strOrganizationID
      					   ,fn_organization_selectlist.intOrder
      					   ,fnInstitution.idfOffice
      					   ,fnInstitution.EnglishFullName
      					   ,fnInstitution.EnglishName
      					   ,fnInstitution.idfsOfficeName
      					   ,fnInstitution.idfsOfficeAbbreviation
      					   ,fnInstitution.idfLocation
      					   ,fnInstitution.strContactPhone
      					   ,fnInstitution.strDefault
      					   ,fnInstitution.idfsSite
      					   ,fnInstitution.intRowStatus
      					   ,fnInstitution.intOrder
      					   ,tlbGeoLocationShared.idfGeoLocationShared
      					   ,tlbGeoLocationShared.idfsResidentType
      					   ,tlbGeoLocationShared.idfsGroundType
      					   ,tlbGeoLocationShared.idfsGeoLocationType
      					   ,tlbGeoLocationShared.idfsCountry
      					   ,tlbGeoLocationShared.idfsRegion
      					   ,tlbGeoLocationShared.idfsRayon
      					   ,tlbGeoLocationShared.idfsSettlement
      					   ,tlbGeoLocationShared.strPostCode
      					   ,tlbGeoLocationShared.strStreetName
      					   ,tlbGeoLocationShared.strHouse
      					   ,tlbGeoLocationShared.strBuilding
      					   ,tlbGeoLocationShared.strApartment
      					   ,tlbGeoLocationShared.strDescription
      					   ,tlbGeoLocationShared.dblDistance
      					   ,tlbGeoLocationShared.dblLatitude
      					   ,tlbGeoLocationShared.dblLongitude
      					   ,tlbGeoLocationShared.dblAccuracy
      					   ,tlbGeoLocationShared.dblAlignment
      					   ,tlbGeoLocationShared.rowguid
      					   ,tlbGeoLocationShared.blnForeignAddress
      					   ,tlbGeoLocationShared.strForeignAddress
      					   ,tlbGeoLocationShared.strAddressString
      					   ,tlbGeoLocationShared.strShortAddressString
      					   ,tlbGeoLocationShared.strMaintenanceFlag
      					   ,tlbGeoLocationShared.strReservedAttribute
						from 
						dbo.fn_organization_selectlist(@l_langid) fn_organization_SelectList 
						INNER join fninstitution(@l_langid)
						on fn_organization_SelectList.idfInstitution=fnInstitution.idfOffice
						inner join tlbGeoLocationShared 
						on fnInstitution.idfLocation=tlbGeoLocationShared.idfGeoLocationShared
					END
			ELSE IF @listWhat='ALL'
				BEGIN
											select 
      					   fn_organization_selectlist.idfInstitution
      					   ,fn_organization_selectlist.FullName
      					   ,fn_organization_selectlist.name
      					   ,fn_organization_selectlist.Address
      					   ,fn_organization_selectlist.intHACode
      					   ,fn_organization_selectlist.strOrganizationID
      					   ,fn_organization_selectlist.intOrder
      					   ,fnInstitution.idfOffice
      					   ,fnInstitution.EnglishFullName
      					   ,fnInstitution.EnglishName
      					   ,fnInstitution.idfsOfficeName
      					   ,fnInstitution.idfsOfficeAbbreviation
      					   ,fnInstitution.idfLocation
      					   ,fnInstitution.strContactPhone
      					   ,fnInstitution.strDefault
      					   ,fnInstitution.idfsSite
      					   ,fnInstitution.intRowStatus
      					   ,fnInstitution.intOrder
      					   ,tlbGeoLocationShared.idfGeoLocationShared
      					   ,tlbGeoLocationShared.idfsResidentType
      					   ,tlbGeoLocationShared.idfsGroundType
      					   ,tlbGeoLocationShared.idfsGeoLocationType
      					   ,tlbGeoLocationShared.idfsCountry
      					   ,tlbGeoLocationShared.idfsRegion
      					   ,tlbGeoLocationShared.idfsRayon
      					   ,tlbGeoLocationShared.idfsSettlement
      					   ,tlbGeoLocationShared.strPostCode
      					   ,tlbGeoLocationShared.strStreetName
      					   ,tlbGeoLocationShared.strHouse
      					   ,tlbGeoLocationShared.strBuilding
      					   ,tlbGeoLocationShared.strApartment
      					   ,tlbGeoLocationShared.strDescription
      					   ,tlbGeoLocationShared.dblDistance
      					   ,tlbGeoLocationShared.dblLatitude
      					   ,tlbGeoLocationShared.dblLongitude
      					   ,tlbGeoLocationShared.dblAccuracy
      					   ,tlbGeoLocationShared.dblAlignment
      					   ,tlbGeoLocationShared.rowguid
      					   ,tlbGeoLocationShared.blnForeignAddress
      					   ,tlbGeoLocationShared.strForeignAddress
      					   ,tlbGeoLocationShared.strAddressString
      					   ,tlbGeoLocationShared.strShortAddressString
      					   ,tlbGeoLocationShared.strMaintenanceFlag
      					   ,tlbGeoLocationShared.strReservedAttribute
						from 
						dbo.fn_organization_selectlist_ALL(@l_langid) fn_organization_SelectList 
						INNER join fninstitution(@l_langid)
						on fn_organization_SelectList.idfInstitution=fnInstitution.idfOffice
						inner join tlbGeoLocationShared 
						on fnInstitution.idfLocation=tlbGeoLocationShared.idfGeoLocationShared
                END

END
