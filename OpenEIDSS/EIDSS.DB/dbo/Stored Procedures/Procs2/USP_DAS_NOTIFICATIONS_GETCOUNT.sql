-- ================================================================================================================
-- NAME: USP_DAS_NOTIFICATIONS_GETCOUNT
-- DESCRIPTION: Returns a count of human disease reports
-- AUTHOR: Ricky Moss
-- 
-- Revision History
-- Name					Date			Change Detail
-- Ricky Moss			05/07/2019		Initial Release
-- Testing Code:
-- exec USP_DAS_NOTIFICATIONS_GETCOUNT
-- ================================================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_NOTIFICATIONS_GETCOUNT]
AS  
BEGIN
	BEGIN TRY
		SELECT		COUNT(hc.idfHumanCase) AS RecordCount
		FROM							dbo.tlbHumanCase hc
		LEFT JOIN						dbo.tlbHuman AS h
		ON								h.idfHuman = hc.idfHuman AND h.intRowStatus = 0 
		LEFT JOIN						dbo.tlbHumanActual AS ha
		ON								ha.idfHumanActual = h.idfHumanActual AND ha.intRowStatus = 0
		LEFT JOIN						dbo.tlbGeoLocation gl
		ON								gl.idfGeoLocation = hc.idfPointGeoLocation AND gl.intRowStatus = 0 	
		LEFT JOIN						dbo.tlbHumanActual AS haPersonEnteredBy 
		ON								haPersonEnteredBy.idfHumanActual = hc.idfPersonEnteredBy AND haPersonEnteredBy.intRowStatus = 0
		AND								hc.intRowStatus = 0	
		WHERE hc.datEnteredDate IS NOT NULL
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END