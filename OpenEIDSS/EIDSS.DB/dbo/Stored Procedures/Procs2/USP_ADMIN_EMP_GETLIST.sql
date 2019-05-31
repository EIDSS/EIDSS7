

--*************************************************************
-- Name 				: USP_ADMIN_EMP_GETLIST
-- Description			: Get list of employees
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_ADMIN_EMP_GETLIST]
		(
	@LangID					AS NVARCHAR(50)
	,@idfEmployee			AS BIGINT			= NULL
	,@strFirstName			AS NVARCHAR(400)	= NULL
	,@strSecondName			AS NVARCHAR(400)	= NULL
	,@strFamilyName			AS NVARCHAR(400)	= NULL
	,@strContactPhone			AS NVARCHAR(400)	= NULL
	,@Organization			AS NVARCHAR(4000)	= NULL
	,@OrganizationFullName	AS NVARCHAR(4000)	= NULL
	,@strOrganizationID		AS NVARCHAR(200)	= NULL
	,@idfInstitution		AS BIGINT			= NULL
	,@Position				AS NVARCHAR(4000)	= NULL
	,@idfPosition			AS BIGINT			= NULL
	,@PageIndex				INT					= 0
    ,@PageSize				INT					= 0
	)

AS

DECLARE @returnCode		INT = 0 
DECLARE	@returnMsg		NVARCHAR(MAX) = 'SUCCESS' 
DECLARE @SearchValue	SQL_VARIANT					-- fnsysSplitList returns "value" as SQL_VARIANT.
DECLARE @StartLoop		BIT = 0

BEGIN
	BEGIN TRY

		DECLARE @sql		NVARCHAR(MAX)
				,@paramlist	NVARCHAR(4000)
				,@nl		CHAR(2) = CHAR(13) + CHAR(10)

		SELECT @sql =
					'SELECT		
					ROW_NUMBER() OVER (ORDER BY tlbPerson.idfPerson ASC) AS RowNumber
					,tlbPerson.idfPerson AS idfEmployee
					,tlbPerson.strFirstName
					,tlbPerson.strSecondName
					,tlbPerson.strFamilyName
					,ISNULL(strFirstName, '''') +  ISNULL('' '' + strFamilyName, '''') as employeeFullName
					,tlbPerson.strContactPhone
					,Org.[name] AS Organization
					,Org.FullName AS OrganizationFullName
					,Org.strOrganizationID
					,tlbPerson.idfInstitution
					,Position.[name] AS Position
					,Position.idfsReference AS idfPosition
				INTO #Results
				FROM	
					tlbPerson
					INNER JOIN tlbEmployee ON
						tlbEmployee.idfEmployee = tlbPerson.idfPerson
						AND 
						tlbEmployee.intRowStatus = 0		
					LEFT JOIN fnReferenceRepair(@LangID, 19000073 /*rftPosition*/) Position	ON
						tlbPerson.idfsStaffPosition = Position.idfsReference
					LEFT JOIN fnInstitution(@LangID) AS Org ON	
						Org.idfOffice = tlbPerson.idfInstitution
				WHERE
					1=1'
			+ @nl
			
			IF ISNULL(@idfEmployee, 0) <> 0
				SELECT @sql += ' AND tlbPerson.idfPerson = @idfEmployee' + @nl

			IF TRIM(ISNULL(@strFirstName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('tlbPerson.strFirstName', @strFirstName) + @nl



			IF TRIM(ISNULL(@strContactPhone, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('tlbPerson.strContactPhone', @strContactPhone) + @nl





			IF TRIM(ISNULL(@strSecondName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('tlbPerson.strSecondName', @strSecondName) + @nl

			IF TRIM(ISNULL(@strFamilyName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('tlbPerson.strFamilyName', @strFamilyName) + @nl

			IF TRIM(ISNULL(@Organization, '')) <> ''
				SELECT @sql += 'AND tlbPerson.idfInstitution = @Organization' + @nl
				--SELECT @sql += dbo.FN_GBL_CreateFilter('tlbPerson.idfInstitution', @Organization) + @nl

			IF TRIM(ISNULL(@OrganizationFullName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('Org.FullName', @OrganizationFullName) + @nl

			IF TRIM(ISNULL(@strOrganizationID, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('Org.strOrganizationID', @strOrganizationID) + @nl

			IF ISNULL(@idfInstitution, 0) <> 0
				SELECT @sql += ' AND idfInstitution = @idfInstitution' + @nl

			IF TRIM(ISNULL(@Position, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('Position.[name]', @Position) + @nl

			IF ISNULL(@idfPosition, 0) <> 0
				SELECT @sql += ' AND Position.idfsReference = @idfPosition' + @nl

		SELECT @paramlist = '@LangID				AS NVARCHAR(50)
							,@idfEmployee			AS BIGINT			= NULL
							,@strFirstName			AS NVARCHAR(400)	= NULL
							,@strSecondName			AS NVARCHAR(400)	= NULL
							,@strFamilyName			AS NVARCHAR(400)	= NULL

							,@strContactPhone		AS NVARCHAR(400)	= NULL

							,@Organization			AS NVARCHAR(4000)	= NULL
							,@OrganizationFullName	AS NVARCHAR(4000)	= NULL
							,@strOrganizationID		AS NVARCHAR(200)	= NULL
							,@idfInstitution		AS BIGINT			= NULL
							,@Position				AS NVARCHAR(4000)	= NULL
							,@idfPosition			AS BIGINT			= NULL
							'
		IF @PageIndex <> 0 
			BEGIN 
				SELECT @sql += 'SELECT * FROM #Results WHERE RowNumber BETWEEN (@PageIndex -1) * @PageSize + 1 AND (((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1' + @nl
				SELECT @sql += 'SELECT COUNT(*) AS RecordCount FROM #Results' + @nl
				SELECT @sql += 'DROP TABLE #Results' + @nl
				SELECT @paramlist += ',@PageIndex	AS INT				= 0
									  ,@PageSize	AS INT				= 0'
				EXEC SP_EXECUTESQL	@sql
									,@paramlist
									,@LangID
									,@idfEmployee
									,@strFirstName
									,@strSecondName
									,@strFamilyName

									,@strContactPhone


									,@Organization
									,@OrganizationFullName
									,@strOrganizationID
									,@idfInstitution
									,@Position
									,@idfPosition
									,@PageIndex
									,@PageSize
			END
		ELSE
			BEGIN
				SELECT @sql += 'SELECT * FROM #Results' + @nl
				EXEC SP_EXECUTESQL	@sql
									,@paramlist
									,@LangID
									,@idfEmployee
									,@strFirstName
									,@strSecondName
									,@strFamilyName

																		,@strContactPhone
									,@Organization
									,@OrganizationFullName
									,@strOrganizationID
									,@idfInstitution
									,@Position
									,@idfPosition
			END

		--PRINT @sql
		--RETURN

		
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
