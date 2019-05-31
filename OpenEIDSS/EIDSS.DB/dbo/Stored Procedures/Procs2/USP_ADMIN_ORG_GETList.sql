
--*************************************************************
-- Name 				: USP_ADMIN_ORG_GETList
-- Description			: Selects lookup list of organizations.
--          
-- Author               : Mandar Kulkarni
-- Revision History
--Name		Date		Change Detail
--JWJ		20180607	added param: @OrganizationTypeID
--
-- Testing code:
--exec USP_ADMIN_ORG_GETList 'en', NULL, 2
--*************************************************************
CREATE      PROCEDURE [dbo].[USP_ADMIN_ORG_GETList]
(
	@LangID				NVARCHAR(50), --##PARAM @LangID - language ID
	@idfOrgID			BIGINT = NULL, --##PARAM @ID - organization ID, if not NULL only record with this organization IS selected
	@strOrganizationID	NVARCHAR(100) = NULL,
	@strOrgName			NVARCHAR(100) = NULL,
	@strOrgFullName		NVARCHAR(100) = NULL,
	@intHACode			INT = NULL,
	@idfsSite			BIGINT = NULL,
	@idfsRegion			BIGINT = NULL,
	@idfsRayon			BIGINT = NULL,
	@idfsSettlement		BIGINT = NULL,
	@OrganizationTypeID	BIGINT = NULL
)
AS
DECLARE @returnCode		INT = 0 
DECLARE	@returnMsg		NVARCHAR(max) = 'SUCCESS' 
DECLARE @sql			NVARCHAR(MAX)
		,@paramlist		NVARCHAR(4000)
		,@nl			CHAR(2) = CHAR(13) + CHAR(10)

BEGIN
	BEGIN TRY

		SELECT @sql = 'SELECT  idfOffice as idfInstitution, 
								[name], 
								FullName, 
								idfsOfficeName, 
								idfsOfficeAbbreviation, 
								CAST(CASE WHEN (intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman,
								CAST(CASE WHEN (intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet,
								CAST(CASE WHEN (intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock,
								CAST(CASE WHEN (intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian,
								CAST(CASE WHEN (intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector,
								CAST(CASE WHEN (intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic,
								intHACode,
								idfsSite,
								strOrganizationID,
								intRowStatus,
								intOrder,
								idfLocation,
      							idfGeoLocationShared,
      							idfsResidentType,
      							idfsGroundType,
      							idfsGeoLocationType,
      							idfsCountry,
								Country,
      							idfsRegion,
								Region,
      							idfsRayon,
								Rayon,
      							idfsSettlement,
								Settlement,
      							strPostCode,
      							strStreetName,
      							strHouse,
      							strBuilding,
      							strApartment,
      							strDescription,
      							dblDistance,
      							dblLatitude,
      							dblLongitude,
      							dblAccuracy,
      							dblAlignment,
      							blnForeignAddress,
      							strForeignAddress,
      							strAddressString,
      							strShortAddressString
						FROM 	dbo.FN_GBL_INSTITUTION(@LangID) 
						WHERE	1 = 1 ' + @nl

			IF ISNULL(@idfOrgID, 0) <> 0
				SELECT @sql += ' AND idfOffice = @idfOrgId' + @nl

			IF TRIM(ISNULL(@strOrganizationID, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('strOrganizationID', @strOrganizationID) + @nl

			IF TRIM(ISNULL(@strOrgName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('[name]', @strOrgName) + @nl

			IF TRIM(ISNULL(@strOrgFullName, '')) <> ''
				SELECT @sql += dbo.FN_GBL_CreateFilter('FullName', @strOrgFullName) + @nl

			IF ISNULL(@intHACode, 0) <> 0
				SELECT @sql += ' AND @intHACode IN (Select intHACode From FN_GBL_SplitHACode(intHACode, 510)) ' + @nl

			IF ISNULL(@idfsSite, 0) <> 0
				SELECT @sql += ' AND idfsSite = @idfsSite' + @nl

			IF ISNULL(@idfsRegion, 0) <> 0
				SELECT @sql += ' AND idfsRegion = @idfsRegion' + @nl

			IF ISNULL(@idfsRayon, 0) <> 0
				SELECT @sql += ' AND idfsRayon = @idfsRayon' + @nl

			IF ISNULL(@idfsSettlement, 0) <> 0
				SELECT @sql += ' AND idfsSettlement = @idfsSettlement' + @nl
			IF ISNULL(@OrganizationTypeID, 0) <> 0
				SELECT @sql += ' AND OrganizationTypeID = @OrganizationTypeID' + @nl

		SELECT @paramlist = '	@LangID					AS NVARCHAR(50)
								,@idfOrgID				BIGINT = NULL
								,@strOrganizationID		NVARCHAR(100) = NULL
								,@strOrgName			NVARCHAR(100) = NULL
								,@strOrgFullName		NVARCHAR(100) = NULL
								,@intHACode				INT = NULL
								,@idfsSite				BIGINT = NULL
								,@OrganizationTypeID	BIGINT = NULL
							'

		--PRINT @sql
		--RETURN

		EXEC SP_EXECUTESQL	@sql
							,@paramlist
							,@LangID
							,@idfOrgID			
							,@strOrganizationID	
							,@strOrgName			
							,@strOrgFullName		
							,@intHACode			
							,@idfsSite
							,@OrganizationTypeID			

			SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
			IF @@Trancount > 0
				ROLLBACK
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg = 
			   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			   + ' ErrorMessage: '+ ERROR_MESSAGE()
			   ----SELECT @LogErrMsg

			  SELECT @returnCode, @returnMsg

	END CATCH
END




