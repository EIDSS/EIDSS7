
--*************************************************************
-- Name 				: USP_VCTS_VSSESSION_GetDetail
-- Description			: Get Vector Surveillance Session data for session id
--          
-- Author               : Harold Pryor
-- Revision History
--		Name		Date       Change Detail
-- Harold Pryor	 4/23/2018	Initial Creation
-- Harold Pryor  6/7/2018   Updated to return idfsGeoLocationType
--
-- Testing code:
-- EXEC USP_VCTS_VSSESSION_GetDetail(1, 'en')
--*************************************************************

CREATE PROCEDURE [dbo].[USP_VCTS_VSSESSION_GetDetail]
(
	@idfVectorSurveillanceSession AS BIGINT ,--##PARAM @idfVectorSurveillanceSession - AS session ID
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @ReturnMsg VARCHAR(MAX)
	SELECT	@ReturnMsg = ''
	DECLARE @ReturnCode BIGINT,
	@SearchSessionID				AS	NVARCHAR(200) = NULL,
	@SearchFieldSessionID			AS	NVARCHAR(200) = NULL,
	@SearchStatus	                AS	BIGINT = NULL,
	@SearchVectorType				AS	NVARCHAR(MAX) = NULL,
	@SearchSpecies					AS	BIGINT = NULL,
	@SearchDisease					AS	BIGINT = NULL,
	@SearchDiagnosesGroup	    	AS	NVARCHAR(MAX) = NULL,
    @vectorsearchFormidfsRegion		AS	BIGINT = NULL,
	@vectorsearchFormidfsRayon		AS	BIGINT = NULL,
	@SearchStartDateFrom			AS	DATETIME = NULL,
	@SearchStartDateTo				AS	DATETIME = NULL,
	@SearchEndDateFrom				AS	DATETIME = NULL,
	@SearchEndDateTo				AS	DATETIME = NULL,
	@OutbreakID					    AS	BIGINT = NULL,
	@SearchDataEntrySite			AS	BIGINT= NULL

	BEGIN TRY  	
    select X.*, Y.strDescription from 
	(SELECT		idfVectorSurveillanceSession,
				strSessionID,
				strVectors,  
				strVectorTypeIds,
				strDiagnoses,
				--vss.strDescription,
				strFieldSessionID,
				strVSStatus,
				idfsVectorSurveillanceStatus,  
				intCollectionEffort,
				idfsGeoLocationType,
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
	
		AND		datStartDate >= CASE ISNULL(@SearchStartDateFrom, '') 
									WHEN '' THEN datStartDate ELSE @SearchStartDateFrom END
		AND		datStartDate <= CASE ISNULL(@SearchStartDateTo, '') 
									WHEN '' THEN datStartDate ELSE @SearchStartDateTo END
		AND		ISNULL(datCloseDate,'') >= CASE ISNULL(@SearchEndDateFrom, '') 
									WHEN '' THEN ISNULL(datCloseDate,'') ELSE @SearchEndDateFrom END
		AND		ISNULL(datCloseDate,'') <= CASE ISNULL(@SearchStartDateTo, '') 
									WHEN '' THEN ISNULL(datCloseDate,'') ELSE @SearchEndDateTo END
		AND		((idfOutbreak = CASE ISNULL(@OutbreakID, '') 
									WHEN '' THEN idfOutbreak ELSE @OutbreakID END) OR idfOutBreak IS NULL)
		AND		((idfsSite = CASE ISNULL(@SearchDataEntrySite, '') 
									WHEN '' THEN idfsSite ELSE @SearchDataEntrySite END) OR idfsSite IS NULL)) X,

         (Select strDescription, idfVectorSurveillanceSession  from dbo.tlbVectorSurveillanceSession) Y
        WHERE X.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		AND Y.idfVectorSurveillanceSession = @idfVectorSurveillanceSession

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
