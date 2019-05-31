
-- ================================================================================================
-- Name: USP_LAB_SAMPLE_BAR_CODE_GETList
--
-- Description:	Get sample list for the laboratory module use case LUC01.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     01/15/2019 Initial release.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_SAMPLE_BAR_CODE_GETList] (
	@LanguageID NVARCHAR(50),
	@SampleList NVARCHAR(MAX)
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT m.idfMaterial AS SampleID,
			m.strBarcode AS EIDSSLaboratorySampleID,
			m.strCalculatedHumanName AS PatientFarmOwnerName
		FROM dbo.tlbMaterial m
		WHERE (m.idfMaterial IN (@SampleList))
		ORDER BY m.strBarcode;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;