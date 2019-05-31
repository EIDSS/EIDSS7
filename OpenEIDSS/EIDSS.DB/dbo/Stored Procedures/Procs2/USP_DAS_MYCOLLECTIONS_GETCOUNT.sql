-- ===============================================================================================
-- Name 				: USP_DAS_MYCOLLECTIONS_GETCOUNT
-- Description			: Returns a count of vectors surveillance sessions collected by a user
--          
-- Author               : Ricky Moss
-- Revision History
-- Name			Date		Change Detail
-- ---------------------------------------------------------------
-- Ricky Moss	05/07/2019  Initial Release
-- Testing code:
-- EXEC USP_DAS_MYCOLLECTIONS_GETCOUNT 'en', 55429560000000
-- EXEC USP_DAS_MYCOLLECTIONS_GETCOUNT 'en', 55423020000000
-- ===============================================================================================
ALTER PROCEDURE [dbo].[USP_DAS_MYCOLLECTIONS_GETCOUNT]
(
	@langId NVARCHAR(15),
	@idfPerson BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT COUNT(DISTINCT	vss.idfVectorSurveillanceSession) AS RecordCount
		FROM	dbo.FN_VCTS_VSSESSION_GetList(@langId) vss
		JOIN	tlbVector v on vss.idfVectorSurveillanceSession = v.idfVectorSurveillanceSession
		WHERE	vss.idfsVectorSurveillanceStatus = 10310001 and v.idfCollectedByPerson = @idfPerson
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END