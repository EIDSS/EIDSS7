--*************************************************************
-- Name 				: [FN_GBL_Institution]
-- Description			: The FUNCTION returns all the Institution details 
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--JWJ	20180611	added OrganizationTypeID
--
-- Testing code:
--SELECT * FROM dbo.FN_GBL_REFERENCEREPAIR('ru')
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_Institution]
(
 @LangID  NVARCHAR(50)
)
RETURNS TABLE
AS
	RETURN( 

			SELECT			tlbOffice.idfOffice, 
							IsNull(s3.strTextString, b1.strDefault) as EnglishFullName,
							IsNull(s4.strTextString, b2.strDefault) as EnglishName,
							IsNull(s1.strTextString, b1.strDefault) as [FullName],
							IsNull(s2.strTextString, b2.strDefault) as [name],
							tlbOffice.idfsOfficeName,
							tlbOffice.idfsOfficeAbbreviation,
							tlbOffice.idfLocation,
							tlbOffice.strContactPhone,
							tlbOffice.intHACode, 
							tlbOffice.strOrganizationID,
							tlbOffice.OrganizationTypeID,
							b1.strDefault, 
							st.idfsSite,
							tlbOffice.intRowStatus,
							b2.intOrder,
      					   tlbGeoLocationShared.idfGeoLocationShared,
      					   tlbGeoLocationShared.idfsResidentType,
      					   tlbGeoLocationShared.idfsGroundType,
      					   tlbGeoLocationShared.idfsGeoLocationType,
      					   tlbGeoLocationShared.idfsCountry,
						   country.name AS Country,
      					   tlbGeoLocationShared.idfsRegion,
						   region.name AS REgion,
      					   tlbGeoLocationShared.idfsRayon,
						   Rayon.name AS Rayon,
      					   tlbGeoLocationShared.idfsSettlement,
						   Settlement.name AS Settlement,
      					   tlbGeoLocationShared.strPostCode,
      					   tlbGeoLocationShared.strStreetName,
      					   tlbGeoLocationShared.strHouse,
      					   tlbGeoLocationShared.strBuilding,
      					   tlbGeoLocationShared.strApartment,
      					   tlbGeoLocationShared.strDescription,
      					   tlbGeoLocationShared.dblDistance,
      					   tlbGeoLocationShared.dblLatitude,
      					   tlbGeoLocationShared.dblLongitude,
      					   tlbGeoLocationShared.dblAccuracy,
      					   tlbGeoLocationShared.dblAlignment,
      					   tlbGeoLocationShared.blnForeignAddress,
      					   tlbGeoLocationShared.strForeignAddress,
      					   tlbGeoLocationShared.strAddressString,
      					   tlbGeoLocationShared.strShortAddressString
			FROM			dbo.tlbOffice
			LEFT OUTER JOIN	dbo.trtBaseReference as b1 
			ON				tlbOffice.idfsOfficeName = b1.idfsBaseReference
							--and b1.intRowStatus = 0
			LEFT JOIN		dbo.trtStringNameTranslation as s1 
			ON				b1.idfsBaseReference = s1.idfsBaseReference
							and s1.idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
			LEFT JOIN		dbo.trtStringNameTranslation as s3 
			ON				b1.idfsBaseReference = s3.idfsBaseReference
							and s3.idfsLanguage = dbo.FN_GBL_LanguageCode_GET('en')

			LEFT OUTER JOIN	dbo.trtBaseReference as b2 
			ON				tlbOffice.idfsOfficeAbbreviation = b2.idfsBaseReference
							--and b2.intRowStatus = 0
			LEFT JOIN		dbo.trtStringNameTranslation as s2 
			ON				b2.idfsBaseReference = s2.idfsBaseReference
							and s2.idfsLanguage = dbo.FN_GBL_LanguageCode_GET(@LangID)
			LEFT JOIN		dbo.trtStringNameTranslation as s4 
			ON				b2.idfsBaseReference = s4.idfsBaseReference
							and s4.idfsLanguage = dbo.FN_GBL_LanguageCode_GET('en')
			INNER JOIN		dbo.tlbGeoLocationShared 
			ON				tlbOffice.idfLocation=tlbGeoLocationShared.idfGeoLocationShared
			LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000003) Region ON
							Region.idfsReference = tlbGeoLocationShared.idfsRegion
			LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon ON	
							Rayon.idfsReference = tlbGeoLocationShared.idfsRayon
			LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000001) Country ON
							Country.idfsReference = tlbGeoLocationShared.idfsCountry
			LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement ON
							Settlement.idfsReference = tlbGeoLocationShared.idfsSettlement

			LEFT JOIN		tstSite as st
			ON				st.idfOffice = tlbOffice.idfOffice
							and st.intRowStatus = 0

		)

