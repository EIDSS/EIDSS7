USE [EIDSS7_DT]
GO
/****** Object:  StoredProcedure [dbo].[USP_OMM_Contact_GetDetail]    Script Date: 5/10/2019 6:56:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--*************************************************************
-- Name: [USP_OMM_Contact_GetDetail]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    Doug Albanese 2/23/2019	Created new SP for obtaining Contact Details
--*************************************************************
ALTER PROCEDURE [dbo].[USP_OMM_Contact_GetDetail]
(    
	@LangID						nvarchar(50),
	@OutbreakCaseContactUID		BIGINT
)
AS

BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SELECT
						H.strLastName,
						H.strFirstName,
						H.strSecondName AS strMiddleName,
						H.datDateofBirth,
						HAI.ReportedAge AS strAge,
						Citizenship.name AS strCitizenship,
						Gender.name AS strGender,
						geo.idfsCountry,
						geo.idfsRegion,
						geo.idfsRayon,
						geo.idfsSettlement,  
						geo.strStreetName,
						geo.strPostCode, 
						geo.strBuilding,
						geo.strHouse,		   
						geo.strApartment,
						geo.strAddressString,
						HAI.ContactPhoneCountryCode + HAI.ContactPhoneNbr As Phone,
						Region.name AS Region,
						Rayon.name AS Rayon,
						Settlement.name AS Settlement,
						OCC.ContactRelationshipTypeID,
						OCC.DateOfLastContact,
						OCC.PlaceOfLastContact,
						OCC.CommentText,
						OCC.ContactStatusID
		FROM
						OutbreakCaseContact OCC
		INNER JOIN		tlbContactedCasePerson CCP
		ON				CCP.idfContactedCasePerson = OCC.ContactedHumanCasePersonID
		INNER JOIN		tlbHuman H
		ON				H.idfHuman = CCP.idfHuman
		LEFT JOIN		FN_GBL_Reference_GETList('en',19000043) Gender
		ON				Gender.idfsReference = H.idfsHumanGender
		LEFT JOIN		tlbGeoLocation geo 
		ON				H.idfCurrentResidenceAddress = geo.idfGeoLocation
		LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID, 19000002) Rayon
		ON				Rayon.idfsReference = geo.idfsRayon
		LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON				Region.idfsReference = geo.idfsRegion
		LEFT JOIN		FN_GBL_GIS_REFERENCE(@LangID,19000004) Settlement
		ON				Settlement.idfsReference = geo.idfsSettlement
		LEFT JOIN		FN_GBL_Reference_GETList(@LangID,19000054) Citizenship
		ON				Citizenship.idfsReference = H.idfsNationality
		INNER JOIN		HumanAddlInfo HAI
		ON				HAI.HumanAdditionalInfo = H.idfHuman
		WHERE
						OCC.OUtbreakCaseContactUID = @OUtbreakCaseContactUID
			
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		throw;
	END CATCH

	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

END