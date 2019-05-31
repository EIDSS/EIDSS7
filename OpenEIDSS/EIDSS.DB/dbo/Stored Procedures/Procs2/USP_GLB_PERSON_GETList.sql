--*************************************************************
-- Name 				: USP_GLB_PERSON_GETList
-- Description			: List Persons based on the filter
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_GLB_PERSON_GETList]
	(
 	@LangID					AS NVARCHAR(50) = 'EN'		--##PARAM @LangID - language ID  
	,@strFirstName			AS NVARCHAR(400) = NULL
	,@strSecondName			AS NVARCHAR(400) = NULL
	,@strFamilyName			AS NVARCHAR(400) = NULL
	,@Organization			AS NVARCHAR(4000) = NULL
	,@OrganizationFullName	AS NVARCHAR(4000) = NULL
	,@strRankName			AS NVARCHAR(4000) = NULL
	)  
AS  

DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN

	BEGIN TRY  	

		SELECT		
			tlbPerson.idfPerson AS idfEmployee, 
			tlbPerson.strFirstName,
			tlbPerson.strSecondName,
			tlbPerson.strFamilyName,
			Organization.[name] AS Organization,
			Organization.FullName AS OrganizationFullName,
			Organization.strOrganizationID,
			tlbPerson.idfInstitution,
			Position.[name] AS strRankName,
			Position.idfsReference AS idfRankName
		FROM	
			tlbPerson
		INNER JOIN	tlbEmployee ON
			tlbEmployee.idfEmployee = tlbPerson.idfPerson
			AND 
			tlbEmployee.intRowStatus = 0		
		LEFT JOIN fnReferenceRepair(@LangID, 19000073 /*rftPosition*/) Position	ON
			tlbPerson.idfsStaffPosition = Position.idfsReference
		LEFT JOIN fnInstitution(@LangID) AS Organization ON
			Organization.idfOffice = tlbPerson.idfInstitution
		WHERE 
			tlbPerson.strFirstName = CASE ISNULL(@strFirstName, '') WHEN '' THEN tlbPerson.strFirstName ELSE @strFirstName END
			AND
			tlbPerson.strSecondName = CASE ISNULL(@strSecondName, '') WHEN '' THEN tlbPerson.strSecondName ELSE @strSecondName END
			AND
			tlbPerson.strFamilyName = CASE ISNULL(@strFamilyName, '') WHEN '' THEN tlbPerson.strFamilyName ELSE @strFamilyName END
			AND
			Organization.[name] = CASE ISNULL(@Organization, '') WHEN '' THEN Organization.[name] ELSE @Organization END
			AND
			Organization.FullName = CASE ISNULL(@OrganizationFullName, '') WHEN '' THEN Organization.FullName ELSE @OrganizationFullName END
			AND
			Position.[name] = CASE ISNULL(@strRankName, '') WHEN '' THEN Position.[name] ELSE @strRankName END

  		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()

		SELECT @returnCode, @returnMsg

	END CATCH
END