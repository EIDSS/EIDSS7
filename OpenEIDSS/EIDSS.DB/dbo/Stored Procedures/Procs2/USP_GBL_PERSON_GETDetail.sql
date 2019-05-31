--*************************************************************
-- Name 				: USP_GBL_PERSON_GETDetail
-- Description			: Input: personid, languageid; Output: person list, group list
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
/*
----testing code:
DECLARE @idfPerson BIGINT 
exec usp_Person_GetDetail @idfPerson, 'en'
*/
--====================================================================================================
 CREATE PROCEDURE [dbo].[USP_GBL_PERSON_GETDetail]

( 
	@idfPerson AS BIGINT, --##PARAM @idfPerson - person ID
	@LangID NVARCHAR(50) --##PARAM @LangID - language ID
)	
AS
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0
BEGIN

	BEGIN TRY  
		SELECT	idfPerson,
				idfsStaffPosition,
				idfInstitution,
				idfDepartment,
				strFamilyName,
				strFirstName,
				strSecondName,
				strContactPhone,
				strBarcode,
				tlbEmployee.idfsSite
		FROM	tlbPerson
		INNER JOIN 	tlbEmployee ON
					tlbPerson.idfPerson=tlbEmployee.idfEmployee
		WHERE 	tlbEmployee.idfEmployee=@idfPerson
		AND		tlbEmployee.intRowStatus=0 
		AND		tlbEmployee.idfsEmployeeType=10023002 --Person 

		--1, User Table jl:BV blocked 4/19/2017 reopen 7/3/2017 based on discussion 

		SELECT	UT.idfUserID,
				UT.idfPerson,
				UT.idfsSite,
				UT.strAccountName,
				S.strSiteID,
				S.strSiteName,
				S.idfsSiteType,
				ISNULL(Rf.name, Rf.strDefault) AS strSiteType
		FROM	dbo.tstUserTable UT
		INNER JOIN dbo.tstSite S ON 
					S.idfsSite = UT.idfsSite And S.intRowStatus = 0
		INNER JOIN dbo.fnReference(@LangID, 19000085/*Site Type*/) Rf ON 
					S.idfsSiteType = Rf.idfsReference
		WHERE	UT.idfPerson=@idfPerson	
		AND		UT.intRowStatus=0

		-- Groups
		SELECT	EG.idfEmployeeGroup,
				EG.idfsEmployeeGroupName,
				E.idfEmployee,
				ISNULL(GroupName.name,EG.strName) AS strName,
				EG.strDescription
		FROM	dbo.tlbEmployeeGroup EG
		INNER JOIN	dbo.tlbEmployeeGroupMember EM ON	
					EM.idfEmployeeGroup=EG.idfEmployeeGroup
		INNER JOIN	dbo.tlbEmployee E ON 
					E.idfEmployee=EM.idfEmployee
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID, 19000022) GroupName ON GroupName.idfsReference = EG.idfsEmployeeGroupName
		WHERE	E.intRowStatus=0 
		AND		EG.idfEmployeeGroup<>-1 
		AND		EG.intRowStatus=0
		AND		EM.intRowStatus = 0
		AND		E.idfEmployee = @idfPerson

		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH  
		BEGIN
			SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
END
