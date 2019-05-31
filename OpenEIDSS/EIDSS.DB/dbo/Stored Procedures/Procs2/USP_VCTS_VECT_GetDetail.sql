
--*************************************************************
-- Name 				: USP_VCTS_VECT_GetDetail
-- Description			: Get Vector Surveillance Vector Details
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
/*
--Example of a call of procedure:
declare	@idfVector	bigint

select @idfVector = MAX(idfVector) from dbo.tlbVector

execute	dbo.USP_VCTS_VECT_GetDetail @idfVectorSurveillanceSession
*/
--*************************************************************
CREATE PROCEDURE[dbo].[USP_VCTS_VECT_GetDetail]
(		
	@idfVectorSurveillanceSession BIGINT,--##PARAM @idfVectorSurveillanceSession - AS session ID
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	

			SELECT 	V.idfVector,
					V.idfVectorSurveillanceSession, 
					VS.strSessionID,
					V.idfsVectorType, 
					VectorType.name	AS [strVectorType],
					VectorSubType.name AS [strSpecies],
					V.idfsSex,	
					Sex.name AS [strSex],
					V.idfsVectorSubType, 
					V.strVectorID, 
					V.strFieldVectorID,
					Vs.intCollectionEffort,
					V.datCollectionDateTime,
					Region.name as strRegion,
					Rayon.name as strRayon

		FROM		dbo.tlbVector V
		INNER JOIN	dbo.tlbVectorSurveillanceSession VS ON V.idfVectorSurveillanceSession = VS.idfVectorSurveillanceSession
		JOIN		dbo.FN_GBL_REFERENCEREPAIR(@LangId,19000141) VectorSubType
		ON			VectorSubType.idfsReference = V.idfsVectorSubType
		JOIN		dbo.FN_GBL_REFERENCEREPAIR(@LangId,19000140) VectorType
		ON			VectorType.idfsReference = V.idfsVectorType
		LEFT JOIN	dbo.FN_GBL_REFERENCEREPAIR(@LangId,19000043) Sex
		ON			Sex.idfsReference = V.idfsSex
		LEFT JOIN	dbo.tlbGeoLocation gl
		ON			gl.idfGeoLocation = V.idfLocation  AND gl.intRowStatus = 0   
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON			Region.idfsReference = gl.idfsRegion
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon
		ON			Rayon.idfsReference = gl.idfsRayon
		WHERE		v.idfVectorSurveillanceSession = @idfVectorSurveillanceSession
		AND			v.intRowStatus = 0  

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
