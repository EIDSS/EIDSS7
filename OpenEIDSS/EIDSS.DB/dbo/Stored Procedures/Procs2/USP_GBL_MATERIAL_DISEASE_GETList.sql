
-- ============================================================================
-- Name: USP_GBL_MATERIAL_DISEASE_GETList
-- Description:	Get sample type by diagnosis matrix list.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/11/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_MATERIAL_DISEASE_GETList] 
(
	@LangID									NVARCHAR(50), 
	@SearchidfsDiagnosis					BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT								m.idfsSampleType,
											sampleType.name AS SampleTypeName
		FROM								dbo.trtMaterialForDisease m 
		LEFT JOIN							FN_GBL_ReferenceRepair(@LangID, 19000087) AS sampleType
		ON									sampleType.idfsReference = m.idfsSampleType 
		LEFT JOIN							dbo.trtMaterialForDiseaseToCP mcp
		ON									mcp.idfMaterialForDisease = m.idfMaterialForDisease 
		WHERE								m.idfsDiagnosis = @SearchidfsDiagnosis
		AND									m.intRowStatus = 0;

		SELECT @returnCode, @returnMsg;
	END TRY  
	BEGIN CATCH 
		BEGIN
			SET @returnCode = ERROR_NUMBER();
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT @returnCode, @returnMsg;
		END
	END CATCH;
END
