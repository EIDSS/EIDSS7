
-- ================================================================================================
-- Name: USP_HUM_HUMAN_GETDetail
-- Description:	Get human actual record
--          
-- Revision History:
-- Name            Date       Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Mandar Kulkarni            Initial release.
-- Vilma Thomas	   05/25/2018 Update the ReferenceType key from 19000167 to 19000500 for 'Contact 
--                            Phone Type'
-- Stephen Long    11/26/2018 Update for the new API; remove returnCode and returnMsg.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_GETDetail]
(
	@LangId			NVARCHAR(20),
	@idfHumanActual BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT	ISNULL(ha.strFirstName, '') + ' ' + ISNULL(ha.strLastName, '') as PatientName,
				haai.EIDSSPersonId,
				ha.idfsOccupationType,
				ha.idfsNationality,
				HumanNationalityCountry.name AS Citizenship,
				ha.idfsHumanGender,
				tb.name as gender,
				ha.idfCurrentResidenceAddress,
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
				tglHuman.blnForeignAddress AS HumanForeignAddressFlag,
				tglHuman.strForeignAddress AS HumanForeignAddressString,
				ha.idfEmployerAddress,
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
				tglEmployer.blnForeignAddress AS EmployerblnForeignAdress,
				tglEmployer.strForeignAddress AS EmployerstrForeignAddress,
				ha.idfRegistrationAddress,
				tglRegistrationAddress.idfsCountry AS HumanAltidfsCountry,
				RegistrationAdressCountry.name AS HumanAltCountry,
				tglRegistrationAddress.idfsRegion AS HumanAltidfsRegion,
				RegistrationAdressRegion.name AS HumanAltRegion,
				tglRegistrationAddress.idfsRayon AS HumanAltidfsRayon,
				RegistrationAddressRayon.name AS HumanAltRayon,
				tglRegistrationAddress.idfsSettlement HumanAltidfsSettlement,
				RegistrationAddressSettlement.name AS HumanAltSettlement,
				tglRegistrationAddress.strPostCode AS HumanAltstrPostalCode,
				tglRegistrationAddress.strStreetName AS HumanAltstrStreetName,
				tglRegistrationAddress.strHouse AS HumanAltstrHouse,
				tglRegistrationAddress.strBuilding AS HumanAltstrBuilding,
				tglRegistrationAddress.strApartment AS HumanAltstrApartment,
				tglRegistrationAddress.strDescription AS HumanAltDescription,
				tglRegistrationAddress.dblLatitude AS HumanAltstrLatitude,
				tglRegistrationAddress.dblLongitude AS HumanAltstrLongitude,
				tglRegistrationAddress.blnForeignAddress AS HumanAltblnForeignAddress,
				tglRegistrationAddress.strForeignAddress AS HumanAltstrForeignAddress,
				tglSchool.idfsCountry AS SchoolidfsCountry, 
				tglSchool.idfsRegion AS SchoolidfsRegion, 
				tglSchool.idfsRayon AS SchoolidfsRayon, 
				tglSchool.idfsSettlement AS SchoolidfsSettlement, 
				tglSchool.strPostCode AS SchoolstrPostalCode,
				tglSchool.strStreetName AS SchoolstrStreetName,
				tglSchool.strHouse AS SchoolstrHouse,
				tglSchool.strBuilding AS SchoolstrBuilding,
				tglSchool.strApartment AS SchoolstrApartment,
				tglSchool.blnForeignAddress AS SchoolblnForeignAdress, 
				tglSchool.strForeignAddress AS SchoolstrForeignAddress, 
				dbo.FN_GBL_FormatDate(ha.datDateofBirth, 'mm/dd/yyyy') As datDateofBirth,
				dbo.FN_GBL_FormatDate(ha.datDateOfDeath, 'mm/dd/yyyy') As datDateOfDeath,
				dbo.FN_GBL_FormatDate(ha.datEnteredDate, 'mm/dd/yyyy') As datEnteredDate,
				dbo.FN_GBL_FormatDate(ha.datModificationDate, 'mm/dd/yyyy') As datModificationDate,
				ha.strFirstName,
				ha.strSecondName,
				ha.strLastName,
				ha.strEmployerName,
				ha.strHomePhone as strRegistrationPhone,
				ha.strWorkPhone,
				ha.idfsPersonIDType,
				ha.strPersonID,
				haai.ReportedAge,
				haai.ReportedAgeUOMID,
				haai.PassportNbr AS strPassportNbr,
				haai.IsEmployedID,
				isEmployed.name isEmployeeFlag,
				haai.EmployerPhoneNbr,
				haai.EmployedDTM,
				haai.IsStudentID,
				isStudent.name AS isStudentFlag,
				haai.SchoolName AS strSchoolName, 
				haai.SchoolLastAttendDTM AS SchoolLastAttendedDTM,
				haai.SchoolPhoneNbr,
				haai.ContactPhoneCountryCode,
				haai.ContactPhoneNbr,
				haai.ContactPhoneNbrTypeID,
				ContactPhoneNbrTypeID.name AS ContactPhoneNbrType,
				haai.ContactPhone2CountryCode,
				haai.ContactPhone2Nbr,
				ContactPhone2NbrTypeID.name AS ContactPhone2NbrType,
				haai.ContactPhone2NbrTypeID, 
				haai.AltAddressID
		FROM	dbo.tlbHumanActual ha
		LEFT JOIN	dbo.HumanActualAddlinfo haai ON
				ha.idfHumanActual = haai.HumanActualAddlinfoUID
		LEFT JOIN	dbo.tlbGeoLocationShared tglHuman ON
				ha.idfCurrentResidenceAddress = tglHuman.idfGeoLocationShared
		LEFT JOIN	dbo.tlbGeoLocationShared tglEmployer ON
				ha.idfEmployerAddress = tglEmployer.idfGeoLocationShared
		LEFT JOIN	dbo.tlbGeoLocationShared tglRegistrationAddress ON
				ha.idfRegistrationAddress = tglRegistrationAddress.idfGeoLocationShared 
		LEFT JOIN	dbo.tlbGeoLocationShared tglSchool ON
				haai.SchoolAddressID = tglSchool.idfGeoLocationShared
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000043) tb ON
					tb.idfsReference = ha.idfsHumanGender
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000001) AS HumanCountry	ON
					tglHuman.idfsCountry = HumanCountry.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000003) AS HumanRegion	ON
					tglHuman.idfsRegion = HumanRegion.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000002) AS HumanRayon ON
					tglHuman.idfsRayon = HumanRayon.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000004) AS HumanSettlement ON
					tglHuman.idfsSettlement = HumanSettlement.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000001) AS EmployerCountry ON
					tglEmployer.idfsCountry = EmployerCountry.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000003) AS EmployerRegion ON
					tglEmployer.idfsRegion = EmployerRegion.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000002) AS EmployerRayon ON
					tglEmployer.idfsRayon = EmployerRayon.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000004) AS EmployerSettlement ON
					tglEmployer.idfsSettlement = EmployerSettlement.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000001) AS RegistrationAdressCountry ON
					tglRegistrationAddress.idfsCountry = RegistrationAdressCountry.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000003) AS RegistrationAdressRegion ON
					tglRegistrationAddress.idfsRegion = RegistrationAdressRegion.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000002) AS RegistrationAddressRayon ON
					tglRegistrationAddress.idfsRayon = RegistrationAddressRayon.idfsReference
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000004) AS RegistrationAddressSettlement ON
					tglRegistrationAddress.idfsSettlement = RegistrationAddressSettlement.idfsReference
		LEFT JOIN	dbo.FN_GBL_Repair(@LangId,19000100) isEmployed ON
					IsEmployed.idfsReference = haai.IsEmployedID
		LEFT JOIN	dbo.FN_GBL_Repair(@LangId,19000100) isStudent ON
					isStudent.idfsReference = haai.IsStudentID
		LEFT JOIN	dbo.FN_GBL_GIS_Reference(@LangId,19000001) AS HumanNationalityCountry	ON
					ha.idfsNationality= HumanNationalityCountry.idfsReference
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000500) AS ContactPhoneNbrTypeID	ON
					ContactPhoneNbrTypeID.idfsReference= haai.ContactPhoneNbrTypeID
		LEFT JOIN	dbo.FN_GBL_ReferenceRepair(@LangId,19000500) AS ContactPhone2NbrTypeID	ON
					ContactPhone2NbrTypeID.idfsReference= haai.ContactPhone2NbrTypeID
		WHERE ha.idfHumanActual = @idfHumanActual;
	END TRY
	BEGIN CATCH
		;THROW;
	END CATCH
END
