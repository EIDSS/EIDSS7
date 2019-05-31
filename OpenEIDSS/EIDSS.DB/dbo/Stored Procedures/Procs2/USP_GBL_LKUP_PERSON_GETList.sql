--*************************************************************
-- Name 				: USP_GBL_LKUP_PERSON_GETList
-- Description			: Selects data for person lookup tables
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
/*
--Example of a call of procedure:

exec  USP_GBL_LKUP_PERSON_GETList 'en', NULL, NULL, 1
*/
--*************************************************************

CREATE PROCEDURE [dbo].[USP_GBL_LKUP_PERSON_GETList]
(
 @LangID		NVARCHAR(50),--##PARAM @LangID - language ID
 @OfficeID		BIGINT = NULL,--##PARAM @OfficeID - person office, if not NULL only persons related with this office are selected
 @ID			BIGINT = NULL, --##PARAM @ID - person ID, if NOT NULL only person with this ID IS selected.
 @ShowUsersOnly BIT = NULL,
 @intHACode		INT = NULL
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

		IF @ShowUsersOnly = 1
			BEGIN
				SELECT		
						tlbPerson.idfPerson, 
						ISNULL(strFamilyName, N'') + ISNULL(' ' + strFirstName, '') + ISNULL(' ' + strSecondName, '') AS FullName ,
						strFamilyName,
						strFirstName,
						FN_GBL_InstitutionRepair.name AS Organization,
						idfOffice, 
						FN_GBL_Reference_GETList.name AS Position,
						tlbEmployee.intRowStatus,
						FN_GBL_InstitutionRepair.intHACode,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic
				FROM	dbo.tlbPerson
				INNER JOIN tlbEmployee ON
						tlbPerson.idfPerson = tlbEmployee.idfEmployee
				LEFT OUTER JOIN dbo.FN_GBL_InstitutionRepair(@LangID) ON
						tlbPerson.idfInstitution = FN_GBL_InstitutionRepair.idfOffice
				LEFT OUTER JOIN dbo.FN_GBL_Reference_GETList(@LangID,19000073) ON --'rftPosition'
						tlbPerson.idfsStaffPosition = FN_GBL_Reference_GETList.idfsReference
				WHERE	idfOffice = ISNULL(NULLIF(@OfficeID,0), idfOffice)
				AND		(@ID IS NULL OR @ID = tlbPerson.idfPerson)
				AND		(@intHACode = 0 OR @intHACode IS NULL OR (FN_GBL_InstitutionRepair.intHACode & @intHACode)>0)
					--intRowStatus IS not used here because we want to show in lookups all users including deleted ones
				AND		EXISTS (SELECT * FROM tstUserTable WHERE tstUserTable.idfPerson = tlbPerson.idfPerson) --Show only employees that have/had logins
				ORDER BY FullName, FN_GBL_InstitutionRepair.name,  FN_GBL_Reference_GETList.name

			END
		ELSE
			BEGIN
				SELECT		
						idfPerson, 
						ISNULL(strFamilyName, N'') + ISNULL(' ' + strFirstName, '') + ISNULL(' ' + strSecondName, '') AS FullName ,
						strFamilyName,
						strFirstName,
						FN_GBL_InstitutionRepair.name AS Organization,
						idfOffice, 
						FN_GBL_Reference_GETList.name AS Position,
						tlbEmployee.intRowStatus,
						FN_GBL_InstitutionRepair.intHACode,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector,
						CAST(CASE WHEN (FN_GBL_InstitutionRepair.intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic
				FROM	dbo.tlbPerson
				INNER JOIN tlbEmployee ON
						tlbPerson.idfPerson = tlbEmployee.idfEmployee
				LEFT OUTER JOIN dbo.FN_GBL_InstitutionRepair(@LangID) ON
						tlbPerson.idfInstitution = FN_GBL_InstitutionRepair.idfOffice
				LEFT OUTER JOIN dbo.FN_GBL_Reference_GETList(@LangID,19000073) ON --'rftPosition'
						tlbPerson.idfsStaffPosition = FN_GBL_Reference_GETList.idfsReference
				WHERE
						idfOffice = ISNULL(NULLIF(@OfficeID,0), idfOffice)
						AND (@ID IS NULL OR @ID = idfPerson)
						AND (@intHACode = 0 OR @intHACode IS NULL OR (FN_GBL_InstitutionRepair.intHACode & @intHACode)>0)
				ORDER BY FullName, FN_GBL_InstitutionRepair.intOrder, FN_GBL_InstitutionRepair.name, FN_GBL_Reference_GETList.name
			END

		SELECT @returnCode, @returnMsg

	END TRY
	BEGIN CATCH
			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
			'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			+ ' ErrorState: ' + convert(varchar,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  convert(varchar,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		  SELECT @returnCode, @returnMsg
	END CATCH
END
