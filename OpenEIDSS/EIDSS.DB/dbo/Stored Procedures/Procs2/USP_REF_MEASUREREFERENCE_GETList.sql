-- ============================================================================
-- Name: USP_REF_MEASUREREFERENCE_GETList
-- Description:	Get the measure references for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/22/2018 Initial release.
-- Ricky Moss		01/18/2018 Removed return codes

-- exec USP_REF_MEASUREREFERENCE_GETList 'en', 19000079
-- exec USP_REF_MEASUREREFERENCE_GETList 'en', 19000074
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_MEASUREREFERENCE_GETList]
 @LangID nvarchar(50),
 @idfsActionList BIGINT
 AS
 BEGIN
	BEGIN TRY
		IF @idfsActionList = 19000074
		BEGIN
		SELECT pa.idfsProphilacticAction as idfsAction
		  ,pabr.strDefault
		  ,pabr.name AS [strName]
		  ,pa.strActionCode AS strActionCode 
		  ,pabr.intOrder
		FROM trtProphilacticAction pa
		INNER JOIN FN_GBL_Reference_GETList(@LangID, 19000074) pabr ON
			pa.idfsProphilacticAction = pabr.idfsReference and pa.intRowStatus = 0
		ORDER BY pabr.intOrder, pabr.strDefault
		END
		ELSE
		BEGIN
		SELECT sa.idfsSanitaryAction as idfsAction
		  ,sabr.strDefault
		  ,sabr.name AS [strName]
		  ,sa.strActionCode AS strActionCode 
		  ,sabr.intOrder
		FROM trtSanitaryAction sa
		INNER JOIN FN_GBL_ReferenceRepair(@LangID, 19000079) sabr ON
			sa.idfsSanitaryAction = sabr.idfsReference and sa.intRowStatus = 0
		ORDER BY sabr.intOrder, sabr.strDefault
		END
	END TRY
	BEGIN CATCH
	THROW;
	END CATCH
 END
