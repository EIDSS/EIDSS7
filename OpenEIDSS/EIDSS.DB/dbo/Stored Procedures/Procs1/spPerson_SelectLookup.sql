


--##SUMMARY Selects data for person lookup tables

--##REMARKS Author: Zurin M.
--##REMARKS Update date: 19.01.2010

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec  spPerson_SelectLookup 'en', NULL, NULL, 1
*/



CREATE          PROCEDURE dbo.spPerson_SelectLookup
	@LangID As nvarchar(50),--##PARAM @LangID - language ID
	@OfficeID as bigint = null,--##PARAM @OfficeID - person office, if not NULL only persons related with this office are selected
	@ID as bigint = NULL, --##PARAM @ID - person ID, if NOT NULL only person with this ID is selected.
	@ShowUsersOnly bit = NULL,
	@intHACode int = NULL
AS
IF @ShowUsersOnly = 1
BEGIN
	SELECT		
		tlbPerson.idfPerson, 
		dbo.fnConcatFullName(strFamilyName, strFirstName, strSecondName) AS FullName,
		strFamilyName,
		strFirstName,
		fnInstitutionRepair.name As Organization,
		idfOffice, 
		fnReference.name As Position,
		tlbEmployee.intRowStatus,
		fnInstitutionRepair.intHACode,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic
	from tlbPerson
	INNER JOIN tlbEmployee ON
		tlbPerson.idfPerson = tlbEmployee.idfEmployee
	LEFT OUTER JOIN dbo.fnInstitutionRepair(@LangID) ON
		tlbPerson.idfInstitution = fnInstitutionRepair.idfOffice
	LEFT OUTER JOIN dbo.fnReference(@LangID,19000073) ON --'rftPosition'
		tlbPerson.idfsStaffPosition = fnReference.idfsReference
	where
		idfOffice = isnull(nullif(@OfficeID,0), idfOffice)
		and (@ID IS NULL OR @ID = tlbPerson.idfPerson)
		and (@intHACode = 0 or @intHACode is null or (fnInstitutionRepair.intHACode & @intHACode)>0)
		--intRowStatus is not used here because we want to show in lookups all users including deleted ones
		AND EXISTS (SELECT * FROM tstUserTable WHERE tstUserTable.idfPerson = tlbPerson.idfPerson) --Show only employees that have/had logins
	order by FullName, fnInstitutionRepair.name,  fnReference.name

END
ELSE
BEGIN
	SELECT		
		idfPerson, 
		dbo.fnConcatFullName(strFamilyName, strFirstName, strSecondName) AS FullName,
		strFamilyName,
		strFirstName,
		fnInstitutionRepair.name As Organization,
		idfOffice, 
		fnReference.name As Position,
		tlbEmployee.intRowStatus,
		fnInstitutionRepair.intHACode,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector,
		CAST(CASE WHEN (fnInstitutionRepair.intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic
	from tlbPerson
	INNER JOIN tlbEmployee ON
		tlbPerson.idfPerson = tlbEmployee.idfEmployee
	LEFT OUTER JOIN dbo.fnInstitutionRepair(@LangID) ON
		tlbPerson.idfInstitution = fnInstitutionRepair.idfOffice
	LEFT OUTER JOIN dbo.fnReference(@LangID,19000073) ON --'rftPosition'
		tlbPerson.idfsStaffPosition = fnReference.idfsReference

	where
		idfOffice = isnull(nullif(@OfficeID,0), idfOffice)
		and (@ID IS NULL OR @ID = idfPerson)
		and (@intHACode = 0 or @intHACode is null or (fnInstitutionRepair.intHACode & @intHACode)>0)
	order by FullName, fnInstitutionRepair.intOrder, fnInstitutionRepair.name, fnReference.name
END



