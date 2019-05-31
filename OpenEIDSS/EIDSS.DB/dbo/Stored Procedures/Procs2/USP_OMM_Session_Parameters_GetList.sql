
--*************************************************************
-- Name: [USP_OMM_Session_GetList]
-- Description: Insert/Update for Campaign Monitoring Session
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Session_Parameters_GetList]
(    
	@LangID			nvarchar(50),
	@idfOutbreak	BIGINT
)
AS

BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
			
		SELECT
			idfOutbreak,
			OutbreakSpeciesTypeID,
			CaseMonitoringDuration,
			CaseMonitoringFrequency,
			ContactTracingDuration,
			ContactTracingFrequency,
			intRowStatus,
			AuditCreateUser,
			AuditCreateDTM,
			AuditUpdateUser,
			AuditUpdateDTM
		FROM
			OutbreakSpeciesParameter
		WHERE
			idfOutbreak = @idfOutbreak AND
			intRowStatus = 0
			
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		throw;
	END CATCH

	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

END