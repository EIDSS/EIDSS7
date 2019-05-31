--*************************************************************
-- Name 				: USP_HUM_DISEASE_CONTACTS_GetList
-- Description			: List Human Disease Report Contacts by HDID
--          
-- Author               : JWJ
-- Revision History
--		Name		Date       Change Detail
-- ---------------- ---------- --------------------------------
-- JWJ				20180618		created 
-- HAP              20190224        Added rowguid to to be returned in resultset

--
-- Testing code:
-- EXEC USP_HUM_DISEASE_CONTACTS_GetList @LangID = 'en', @idfHumanCase  = 14  
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_CONTACTS_GetList] 
@idfHumanCase 	bigint,		
@LangID			nvarchar(50)
AS
Begin
	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;

BEGIN TRY  
		select  
		   ccp.idfContactedCasePerson,  
		   ccp.idfHumanCase,  
		   ccp.idfHuman,       
     
		   --grid list
		   h.idfHumanActual as idfRootHuman,  
		   dbo.fnConcatFullName(h.strLastName, h.strFirstName, h.strSecondName) as strContactPersonFullName,
		   ccp.idfsPersonContactType, 
		   br.strDefault as strPersonContactType, 
		   ccp.datDateOfLastContact,
		   ccp.strPlaceInfo,
		   ccp.strComments,

		   --detail popup
		   h.strFirstName,
		   h.strSecondName,
		   h.strLastName,
		   h.datDateofBirth,
		   h.idfsHumanGender,
		   h.idfsNationality as idfCitizenship,
		   'find' as strContactPhone,
		   '0' as idfContactPhoneType,
		   --'find' as strPhoneType,

		   geo.idfsCountry,
		   geo.idfsRegion,
		   geo.idfsRayon,
		   geo.idfsSettlement,  
		   geo.strStreetName,
		   geo.strPostCode, 
		   geo.strBuilding,
		   geo.strHouse,		   
		   geo.strApartment,
 
    
		   (ISNULL([Address].name, [Address].strDefault) + IsNull(', ' + h.strHomePhone, '')) AS strPatientInformation,     
		   ISNULL([Address].name, [Address].strDefault) as strPatientAddressString,
		   cast(0 as tinyint) as bitIsRootMain,
		   ccp.rowguid
   
		from  tlbContactedCasePerson  ccp
		inner join tlbHumanCase  hc
			on   hc.idfHumanCase = ccp.idfHumanCase  
		   and hc.intRowStatus = 0  
		inner join tlbHuman h 
			ON   h.idfHuman = ccp.idfHuman  
		   and h.intRowStatus = 0  
		inner join trtBaseReference br 
			on   ccp.idfsPersonContactType = br.idfsBaseReference  
		left join dbo.fnGeoLocationTranslation(@LangID) [Address] 
			ON [Address].idfGeoLocation = h.idfCurrentResidenceAddress  
		left join dbo.tlbGeoLocation geo 
			ON h.idfCurrentResidenceAddress = geo.idfGeoLocation

		where  
			ccp.idfHumanCase = @idfHumanCase  
			and 
			ccp.intRowStatus = 0 


		SELECT @returnCode 'ReturnCode', @returnMsg 'ResturnMessage';
	END TRY  

	BEGIN CATCH 
	THROW
	END CATCH;
END
