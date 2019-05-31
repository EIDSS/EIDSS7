
--*************************************************************
-- Name 				: USP_VCTS_VecSessionSummary_GETList
-- Description			: Get Vector Surveillance Summary List
--          
-- Author               : MANDar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
/*
--Example of a call of procedure:
execute	dbo.USP_VCTS_VecSessionSummary_GETList @idfVectorSurveillanceSession
*/
Create PROCEDURE [dbo].[USP_VCTS_VecSessionSummary_GETList]
(
	@idfVectorSurveillanceSession	BIGINT--##PARAM @idfVectorSurveillanceSession - session ID
	,@LangID						NVARCHAR(50)--##PARAM @LangID - language ID
)
AS
BEGIN	
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  		
			SELECT Vss.[idfsVSSessionSummary]
				  ,Vss.[idfVectorSurveillanceSession]
				  ,Vss.[strVSSessionSummaryID] -- RecordID
				  ,Vss.[idfGeoLocation]
				  ,country.name AS Country
				  ,region.name AS Region
				  ,rayon.name AS Rayon
				  ,Settlement.name AS Settlement
				  ,Vss.[datCollectionDateTime]
				  ,Vst.idfsVectorType
				  ,VectorType.name As [strVectorType]
				  ,Vss.[idfsVectorSubType]
				  ,VectorSubType.name As [strVectorSubType]
				  ,Vss.[idfsSex]
				  ,Sex.name As [strSex]	
				  ,Vss.[intQuantity]
				  ,Vss.[intRowStatus]	  
			FROM dbo.tlbVectorSurveillanceSessionSummary Vss
			INNER JOIN dbo.trtVectorSubType Vst ON Vss.idfsVectorSubType = Vst.idfsVectorSubType And Vst.intRowStatus = 0
			INNER JOIN dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000140) VectorType ON	VectorType.idfsReference = Vst.idfsVectorType
			INNER JOIN dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000141) VectorSubType ON VectorSubType.idfsReference = Vss.idfsVectorSubType
			LEFT JOIN dbo.FN_GBL_REFERENCEREPAIR(@LangID,19000007) Sex ON	Sex.idfsReference = Vss.idfsSex
			LEFT JOIN dbo.tlbGeoLocation gl	ON gl.idfGeoLocation = Vss.idfGeoLocation
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID,19000003) Region ON Region.idfsReference = gl.idfsRegion
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID,19000002) Rayon ON	Rayon.idfsReference = gl.idfsRayon
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID,19000001) Country ON	Country.idfsReference = gl.idfsCountry  
			LEFT JOIN dbo.FN_GBL_GIS_Reference(@LangID,19000004) Settlement ON Settlement.idfsReference = gl.idfsSettlement
			WHERE 	Vss.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
			AND		Vss.intRowStatus = 0
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

			SET @returnCode = ERROR_NUMBER()
			SELECT @returnCode, @returnMsg
		END

	END CATCH; 
END
