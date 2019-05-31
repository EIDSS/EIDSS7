

--*************************************************************
-- Name: [USP_OMM_CaseSummary_GetDetail]
-- Description: Get Summary Detail for a person
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_CaseSummary_GetDetail]
(    
	@LangID									nvarchar(50),
	@idfHumanActual							BIGINT
)
AS

BEGIN    

	DECLARE	@returnCode						INT = 0;
	DECLARE @returnMsg						NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY

		SELECT	ISNULL(ha.strFirstName, '') + ' ' + ISNULL(ha.strLastName, '') as Person,
				haai.EIDSSPersonId
		FROM	dbo.tlbHumanActual ha
		LEFT JOIN	dbo.HumanActualAddlinfo haai ON
				ha.idfHumanActual = haai.HumanActualAddlinfoUID
		
		WHERE ha.idfHumanActual = @idfHumanActual;
		
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		throw;
	END CATCH

	SELECT	@returnCode, @returnMsg;

END
