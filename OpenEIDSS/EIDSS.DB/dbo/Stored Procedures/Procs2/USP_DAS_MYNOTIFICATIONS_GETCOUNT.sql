-- ================================================================================================================
-- NAME: USP_DAS_MYNOTIFICATIONS_GETCOUNT
-- DESCRIPTION: Returns a count of human disease reports based on the user currently logged in
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name					Date			Change Detail
-- Ricky Moss			05/07/2018		Initial Release
-- Testing Code:
-- exec USP_DAS_MYNOTIFICATIONS_GETCOUNT 55541620000016
-- ================================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_MYNOTIFICATIONS_GETCOUNT]
(
	@idfPerson BIGINT
)
AS  
BEGIN
	BEGIN TRY
		SELECT COUNT(hc.idfHumanCase) AS RecordCount
		FROM							dbo.tlbHumanCase hc
		LEFT JOIN						dbo.tlbHuman AS h
		ON								h.idfHuman = hc.idfHuman AND h.intRowStatus = 0 
		LEFT JOIN						dbo.tlbHumanActual AS ha
		ON								ha.idfHumanActual = h.idfHumanActual AND ha.intRowStatus = 0
		
		LEFT JOIN						dbo.tlbHuman AS haInvestigatedBy 
		ON								haInvestigatedBy.idfHuman = hc.idfInvestigatedByPerson AND haInvestigatedBy.intRowStatus = 0
		AND								hc.intRowStatus = 0
		WHERE hc.datEnteredDate is not null and idfPersonEnteredBy = @idfPerson
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
