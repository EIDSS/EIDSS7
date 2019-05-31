-- ============================================================================
-- Name: USP_REF_SPECIESTYPE_GETList
-- Description:	Get the Species Type for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss       10/11/2018 Initial release.
-- Ricky Moss		12/12/2018	Removed return code, HA Code list and reference id variables
-- Ricky Moss		01/27/2019	Replaced deprecating reference function
--
-- exec USP_REF_SPECIESTYPE_GETList 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_SPECIESTYPE_GETList] 
(
	@LangID AS NVARCHAR(50)
)
AS
BEGIN
BEGIN TRY
	SELECT 
		tst.idfsSpeciesType
		,sl.strDefault
		,sl.[name] AS strName
		,tst.strCode
		,sl.intHACode
		,dbo.FN_GBL_HACodeNames_ToCSV(@LangID, sl.[intHACode]) AS [strHACodeNames]
		,sl.intOrder
	FROM dbo.FN_GBL_ReferenceRepair(@LangID, 19000086) sl 
	INNER JOIN trtSpeciesType tst 
	ON tst.idfsSpeciesType = sl.idfsReference
	WHERE (sl.intHACode IS NULL 
		OR sl.intHACode > 0)
		AND TST.intRowStatus = 0
	ORDER BY sl.intOrder
		, sl.[name] 

		--EXEC usp_HACode_GetCheckList 'en';
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END