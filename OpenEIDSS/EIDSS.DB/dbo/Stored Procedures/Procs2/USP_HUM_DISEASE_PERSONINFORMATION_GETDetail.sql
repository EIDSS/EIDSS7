
-- ================================================================================================
-- Name: USP_HUM_DISEASE_PERSONINFORMATION_GETDetail
-- Description:	Get a human record
--          
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Harold Pryor    4/4/2019    Initial release.
--                        
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_PERSONINFORMATION_GETDetail]
(
	@LanguageID			NVARCHAR(20),
	@idfHuman			BIGINT,
	@idfHumanActual		BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT			ISNULL(ha.strFirstName, '') + ' ' + ISNULL(ha.strLastName, '') AS PatientFarmOwnerName,
						haai.EIDSSPersonId AS EIDSSPersonID,
						ha.idfsOccupationType AS OccupationTypeID,
						ha.idfsNationality AS CitizenshipTypeID,
						citizenshipType.name AS CitizenshipTypeName,
						ha.idfsHumanGender AS GenderTypeID,
						tb.name AS GenderTypeName,
						ha.idfCurrentResidenceAddress AS HumanGeoLocationID,
						tglHuman.idfsCountry AS HumanidfsCountry,
						humanCountry.name AS HumanCountry,
						tglHuman.idfsRegion AS HumanidfsRegion,
						humanRegion.name AS HumanRegion,
						tglHuman.idfsRayon AS HumanidfsRayon,
						humanRayon.name AS HumanRayon,
						tglHuman.idfsSettlement AS HumanidfsSettlement,
						humanSettlement.name AS HumanSettlement,
						tglHuman.strPostCode AS HumanstrPostalCode,
						tglHuman.strStreetName AS HumanstrStreetName,
						tglHuman.strHouse AS HumanstrHouse,
						tglHuman.strBuilding AS HumanstrBuilding,
						tglHuman.strApartment AS HumanstrApartment,
						tglHuman.strDescription AS HumanDescription,
						tglHuman.dblLatitude AS HumanstrLatitude,
						tglHuman.dblLongitude AS HumanstrLongitude, 
						tglHuman.blnForeignAddress AS HumanForeignAddressIndicator,
						tglHuman.strForeignAddress AS HumanForeignAddressString,
						ha.idfEmployerAddress AS EmployerGeoLocationID,
						tglEmployer.idfsCountry AS EmployeridfsCountry,
						employerCountry.name AS EmployerCountry,
						tglEmployer.idfsRegion AS EmployeridfsRegion,
						employerRegion.name AS EmployerRegion,
						tglEmployer.idfsRayon AS EmployeridfsRayon,
						employerRayon.name AS EmployerRayon,
						tglEmployer.idfsSettlement AS EmployeridfsSettlement,
						employerSettlement.name AS EmployerSettlement,
						tglEmployer.strPostCode AS EmployerstrPostalCode,
						tglEmployer.strStreetName AS EmployerstrStreetName,
						tglEmployer.strHouse AS EmployerstrHouse,
						tglEmployer.strBuilding AS EmployerstrBuilding,
						tglEmployer.strApartment AS EmployerstrApartment,
						tglEmployer.strDescription AS EmployerDescription,
						tglEmployer.dblLatitude AS EmployerstrLatitude,
						tglEmployer.dblLongitude AS EmployerstrLongitude,
						tglEmployer.blnForeignAddress AS EmployerForeignAddressIndicator,
						tglEmployer.strForeignAddress AS EmployerForeignAddressString,
						ha.idfRegistrationAddress AS HumanAltGeoLocationID,
						tglRegistrationAddress.idfsCountry AS HumanAltidfsCountry,
						registrationAdressCountry.name AS HumanAltCountry,
						tglRegistrationAddress.idfsRegion AS HumanAltidfsRegion,
						registrationAdressRegion.name AS HumanAltRegion,
						tglRegistrationAddress.idfsRayon AS HumanAltidfsRayon,
						registrationAddressRayon.name AS HumanAltRayon,
						tglRegistrationAddress.idfsSettlement HumanAltidfsSettlement,
						registrationAddressSettlement.name AS HumanAltSettlement,
						tglRegistrationAddress.strPostCode AS HumanAltstrPostalCode,
						tglRegistrationAddress.strStreetName AS HumanAltstrStreetName,
						tglRegistrationAddress.strHouse AS HumanAltstrHouse,
						tglRegistrationAddress.strBuilding AS HumanAltstrBuilding,
						tglRegistrationAddress.strApartment AS HumanAltstrApartment,
						tglRegistrationAddress.strDescription AS HumanAltDescription,
						tglRegistrationAddress.dblLatitude AS HumanAltstrLatitude,
						tglRegistrationAddress.dblLongitude AS HumanAltstrLongitude,
						tglRegistrationAddress.blnForeignAddress AS HumanAltForeignAddressIndicator,
						tglRegistrationAddress.strForeignAddress AS HumanAltForeignAddressString,
						haai.AltAddressID AS SchoolGeoLocationID, 
						tglSchool.idfsCountry AS SchoolidfsCountry, 
						tglSchool.idfsRegion AS SchoolidfsRegion, 
						tglSchool.idfsRayon AS SchoolidfsRayon, 
						tglSchool.idfsSettlement AS SchoolidfsSettlement, 
						tglSchool.strPostCode AS SchoolstrPostalCode,
						tglSchool.strStreetName AS SchoolstrStreetName,
						tglSchool.strHouse AS SchoolstrHouse,
						tglSchool.strBuilding AS SchoolstrBuilding,
						tglSchool.strApartment AS SchoolstrApartment,
						tglSchool.blnForeignAddress AS SchoolForeignAddressIndicator, 
						tglSchool.strForeignAddress AS SchoolForeignAddressString, 
						dbo.FN_GBL_FormatDate(ha.datDateofBirth, 'mm/dd/yyyy') As DateOfBirth,
						dbo.FN_GBL_FormatDate(ha.datDateOfDeath, 'mm/dd/yyyy') As DateOfDeath,
						dbo.FN_GBL_FormatDate(ha.datEnteredDate, 'mm/dd/yyyy') As EnteredDate,
						dbo.FN_GBL_FormatDate(ha.datModificationDate, 'mm/dd/yyyy') As ModificationDate,
						ha.strFirstName AS FirstOrGivenName,
						ha.strSecondName AS SecondName,
						ha.strLastName AS LastOrSurname,
						ha.strEmployerName AS EmployerName,
						ha.strHomePhone as HomePhone,
						ha.strWorkPhone AS WorkPhone,
						ha.idfsPersonIDType AS PersonalIDType,
						ha.strPersonID AS PersonalID,
						haai.ReportedAge,
						haai.ReportedAgeUOMID,
						haai.PassportNbr AS PassportNumber,
						haai.IsEmployedID AS IsEmployedTypeID,
						isEmployed.name AS IsEmployedTypeName,
						haai.EmployerPhoneNbr AS EmployerPhone,
						haai.EmployedDTM AS EmployedDateLastPresent,
						haai.IsStudentID AS IsStudentTypeID,
						isStudent.name AS IsStudentTypeName,
						haai.SchoolName AS SchoolName, 
						haai.SchoolLastAttendDTM AS SchoolDateLastAttended,
						haai.SchoolPhoneNbr AS SchoolPhone,
						haai.ContactPhoneCountryCode,
						haai.ContactPhoneNbr AS ContactPhone,
						haai.ContactPhoneNbrTypeID AS ContactPhoneTypeID,
						ContactPhoneNbrTypeID.name AS ContactPhoneTypeName,
						haai.ContactPhone2CountryCode,
						haai.ContactPhone2Nbr AS ContactPhone2,
						haai.ContactPhone2NbrTypeID AS ContactPhone2TypeID, 
						ContactPhone2NbrTypeID.name AS ContactPhone2TypeName 
		FROM			dbo.tlbHuman ha
		LEFT JOIN		dbo.HumanActualAddlinfo haai ON
						ha.idfHumanActual = haai.HumanActualAddlinfoUID
		LEFT JOIN		dbo.tlbGeoLocationShared AS tglHuman ON
						ha.idfCurrentResidenceAddress = tglHuman.idfGeoLocationShared
		LEFT JOIN		dbo.tlbGeoLocationShared AS tglEmployer ON
						ha.idfEmployerAddress = tglEmployer.idfGeoLocationShared
		LEFT JOIN		dbo.tlbGeoLocationShared AS tglRegistrationAddress ON
						ha.idfRegistrationAddress = tglRegistrationAddress.idfGeoLocationShared 
		LEFT JOIN		dbo.tlbGeoLocationShared AS tglSchool ON
						haai.SchoolAddressID = tglSchool.idfGeoLocationShared
		LEFT JOIN		dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000043) tb ON
						tb.idfsReference = ha.idfsHumanGender
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS humanCountry	ON
						tglHuman.idfsCountry = humanCountry.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS humanRegion	ON
						tglHuman.idfsRegion = humanRegion.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS humanRayon ON
						tglHuman.idfsRayon = humanRayon.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS humanSettlement ON
						tglHuman.idfsSettlement = humanSettlement.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS employerCountry ON
						tglEmployer.idfsCountry = employerCountry.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS employerRegion ON
						tglEmployer.idfsRegion = employerRegion.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS employerRayon ON
						tglEmployer.idfsRayon = employerRayon.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS employerSettlement ON
						tglEmployer.idfsSettlement = EmployerSettlement.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS registrationAdressCountry ON
						tglRegistrationAddress.idfsCountry = registrationAdressCountry.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS registrationAdressRegion ON
						tglRegistrationAddress.idfsRegion = registrationAdressRegion.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS registrationAddressRayon ON
						tglRegistrationAddress.idfsRayon = registrationAddressRayon.idfsReference
		LEFT JOIN		dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS RegistrationAddressSettlement ON
						tglRegistrationAddress.idfsSettlement = registrationAddressSettlement.idfsReference
		LEFT JOIN		dbo.FN_GBL_Repair(@LanguageID, 19000100) isEmployed ON
						IsEmployed.idfsReference = haai.IsEmployedID
		LEFT JOIN		dbo.FN_GBL_Repair(@LanguageID, 19000100) isStudent ON
						isStudent.idfsReference = haai.IsStudentID
		LEFT JOIN		dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000054) AS citizenshipType	ON
						ha.idfsNationality= citizenshipType.idfsReference
		LEFT JOIN		dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000500) AS contactPhoneNbrTypeID	ON
						contactPhoneNbrTypeID.idfsReference= haai.ContactPhoneNbrTypeID
		LEFT JOIN		dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000500) AS contactPhone2NbrTypeID	ON
						contactPhone2NbrTypeID.idfsReference= haai.ContactPhone2NbrTypeID
		WHERE ha.idfHuman = @idfHuman		
			  and ha.idfHumanActual = @idfHumanActual;
	END TRY
	BEGIN CATCH
		;THROW;
	END CATCH
END
