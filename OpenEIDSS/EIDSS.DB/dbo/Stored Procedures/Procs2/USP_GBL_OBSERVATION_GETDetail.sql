






-- ============================================================================
-- Name: USP_GBL_OBSERVATION_GETDetail
-- Description:	Get observation detail (one record) for various use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_GBL_OBSERVATION_GETDetail] 
(
	@LangID									NVARCHAR(50), 
	@idfObservation							BIGINT = NULL
)
AS
BEGIN
	DECLARE @returnMsg						VARCHAR(MAX) = 'SUCCESS';
	DECLARE @returnCode						BIGINT = 0;

	BEGIN TRY  	
		SELECT						
											o.idfObservation,
											o.idfsFormTemplate, 
											o.intRowStatus, 
											o.strMaintenanceFlag,
											o.idfsSite, 
											observationSite.strSiteName AS ObservationSiteName
		FROM								dbo.tlbObservation o 
		LEFT JOIN							dbo.tstSite AS observationSite
		ON									observationSite.idfsSite = o.idfsSite AND observationSite.intRowStatus = 0
		LEFT JOIN							dbo.tlbTesting AS t 
		ON									t.idfObservation = o.idfObservation AND t.intRowStatus = 0 
		LEFT JOIN							dbo.tlbAnimal AS a
		ON									a.idfObservation = o.idfObservation
		LEFT JOIN							dbo.tlbSpecies AS s
		ON									s.idfObservation = o.idfObservation AND s.intRowStatus = 0 
		LEFT JOIN							dbo.tlbHerd AS h 
		ON									h.idfHerd = s.idfHerd AND h.intRowStatus = 0 
		LEFT JOIN							dbo.tlbFarm AS f
		ON									f.idfFarm = h.idfFarm AND f.intRowStatus = 0 
		WHERE								o.idfObservation = @idfObservation
		AND									o.intRowStatus = 0;

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
