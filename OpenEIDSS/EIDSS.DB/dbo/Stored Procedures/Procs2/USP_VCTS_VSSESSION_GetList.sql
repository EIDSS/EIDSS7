
--*************************************************************
-- Name 				: USP_VCTS_VSSESSION_GetList
-- Description			: List All Vector Surveillance Session data
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name		Date       Change Detail
-- MORar Kulkarni	1/3/2017	Added additional search parameters
-- Harold Pryor     5/6/2018    Added additional search parameter @vectorsearchFormidfsSettlement
-- Harold Pryor     6/6/2018    Updated to properly return data when datCloseDate field is equal to null
-- Harold Pryor     7/18/2018   Updated to properly return data for @SearchStartDateTo parameter search filter
--
-- Testing code:
-- EXEC USP_VCTS_VSSESSION_GetList('en')
--*************************************************************

CREATE PROCEDURE [dbo].[USP_VCTS_VSSESSION_GetList]
(
	@LangID							AS	NVARCHAR(50), --##PARAM @LangID - language ID
	@SearchSessionID				AS	NVARCHAR(200) = NULL,
	@SearchFieldSessionID			AS	NVARCHAR(200) = NULL,
	@SearchStatus	                AS	BIGINT = NULL,
	@SearchVectorType				AS	NVARCHAR(MAX) = NULL,
	@SearchSpecies					AS	BIGINT = NULL,
	@SearchDisease					AS	BIGINT = NULL,
	@SearchDiagnosesGroup	    	AS	NVARCHAR(MAX) = NULL,
    @vectorsearchFormidfsRegion		AS	BIGINT = NULL,
	@vectorsearchFormidfsRayon		AS	BIGINT = NULL,
	@vectorsearchFormidfsSettlement	AS	BIGINT = NULL,
	@SearchStartDateFrom			AS	DATETIME = NULL,
	@SearchStartDateTo				AS	DATETIME = NULL,
	@SearchEndDateFrom				AS	DATETIME = NULL,
	@SearchEndDateTo				AS	DATETIME = NULL,
	@OutbreakID					    AS	BIGINT = NULL,
	@SearchDataEntrySite			AS	BIGINT= NULL
)
AS
BEGIN
	DECLARE @ReturnMsg VARCHAR(MAX)
	SELECT	@ReturnMsg = ''
	DECLARE @ReturnCode BIGINT

	BEGIN TRY  	

	SELECT	distinct	idfVectorSurveillanceSession,
				strSessionID,
				strVectors,  
				strVectorTypeIds,
				strDiagnoses,
				--vss.strDescription,
				strFieldSessionID,
				strVSStatus,
				idfsVectorSurveillanceStatus,  
				intCollectionEffort,
				strCountry,
				idfsCountry,
				strRegion,
				idfsRegion,
				strRayon,
				idfsSettlement,
				strSettlement,  
				idfsRayon,
				dblLatitude,
				dblLongitude,
				datStartDate,
				datCloseDate,  
				idfOutbreak,
				idfLocation,
				idfsSite
		FROM	dbo.FN_VCTS_VSSESSION_GetList(@LangID) 
		WHERE	((strSessionID LIKE CASE ISNULL(@SearchSessionID, '') WHEN '' THEN strSessionID ELSE '%'+ @SearchSessionID+'%' END) OR strSessionID IS NULL)
		AND		((strFieldSessionID LIKE CASE ISNULL(@SearchFieldSessionID, '') WHEN '' THEN strFieldSessionID ELSE '%' + @SearchFieldSessionID +'%' END) OR strFieldSessionID IS NULL)
		AND		idfsVectorSurveillanceStatus = CASE ISNULL(@SearchStatus, '') 
									WHEN '' THEN idfsVectorSurveillanceStatus ELSE @SearchStatus END
		AND		((strVectorTypeIds = CASE ISNULL(@SearchVectorType, '') 
									WHEN '' THEN strVectorTypeIds ELSE @SearchVectorType END) OR strVectorTypeIds IS NULL)
		AND		((idfsVectorSubType = CASE ISNULL(@SearchSpecies, '') 
									WHEN '' THEN idfsVectorSubType ELSE @SearchSpecies END) OR idfsVectorSubType IS NULL)
		AND		((strDiagnoses LIKE CASE ISNULL(@SearchDiagnosesGroup, '') 
									WHEN '' THEN strDiagnoses ELSE '%' + @SearchDiagnosesGroup+'%'  END) OR strDiagnoses IS NULL)
		AND		((idfsRegion = CASE ISNULL(@vectorsearchFormidfsRegion, '') 
									WHEN '' THEN idfsRegion ELSE @vectorsearchFormidfsRegion END) OR idfsRegion IS NULL)
		AND		((idfsRayon = CASE ISNULL(@vectorsearchFormidfsRayon, '') 
									WHEN '' THEN idfsRayon ELSE @vectorsearchFormidfsRayon END) OR idfsRayon IS NULL)
        AND		((idfsSettlement = CASE ISNULL(@vectorsearchFormidfsSettlement, '') 
									WHEN '' THEN idfsSettlement ELSE @vectorsearchFormidfsSettlement END) OR idfsSettlement IS NULL) 	
		AND		datStartDate >= CASE ISNULL(@SearchStartDateFrom, '') 
									WHEN '' THEN datStartDate ELSE @SearchStartDateFrom END
		AND		datStartDate <= CASE ISNULL(@SearchStartDateTo, '') 
									WHEN '' THEN datStartDate ELSE @SearchStartDateTo END
		AND		ISNULL(datCloseDate,'') >= CASE ISNULL(@SearchEndDateFrom, '') 
									WHEN '' THEN ISNULL(datCloseDate,'') ELSE @SearchEndDateFrom END
		AND		ISNULL(datCloseDate,'') <= CASE ISNULL(@SearchEndDateTo, '') 
									WHEN '' THEN ISNULL(datCloseDate,'') ELSE @SearchEndDateTo END
		AND		((idfOutbreak = CASE ISNULL(@OutbreakID, '') 
									WHEN '' THEN idfOutbreak ELSE @OutbreakID END) OR idfOutBreak IS NULL)
		AND		((idfsSite = CASE ISNULL(@SearchDataEntrySite, '') 
									WHEN '' THEN idfsSite ELSE @SearchDataEntrySite END) OR idfsSite IS NULL)
	

		SELECT 0, 'Success'

	END TRY  

	BEGIN CATCH 

		BEGIN
			SET @ReturnCode = ERROR_NUMBER()
			SET @ReturnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @returnCode, @ReturnMsg
		END

	END CATCH;
END
