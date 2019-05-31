
--=====================================================================================================
-- Author:		Original Author Unknown
-- Description:	Returns two (2) result sets.
--
-- 1) Selects detail data for statistic types
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/12/2018  Initial Release
-- Ricky Moss		12/20/2018	Removed return codes
-- 
-- Test Code:
-- EXEC USP_REF_STATISTICDATATYPE_GETList 'en'
-- 
--=====================================================================================================

CREATE PROCEDURE [dbo].[USP_REF_STATISTICDATATYPE_GETList]
(
	@LangID		NVARCHAR(50)
)
AS
BEGIN
BEGIN TRY
	SELECT
		sdt.[idfsStatisticDataType],
		sdt.[idfsReferenceType],
		sdtpt.[name] as strParameterType,
		sdtbr.strDefault as [strDefault],
		sdtbr.[name] as [strName],
		ISNULL(sdt.[blnRelatedWithAgeGroup], 0) as [blnStatisticalAgeGroup],  -- statistical age group info needed per use case SAUC49
		sdt.[idfsStatisticPeriodType],
		sptbr.[name] as [strStatisticPeriodType], 
		sdt.[idfsStatisticAreaType],
		satbr.[name] as [strStatisticalAreaType]

	FROM [trtStatisticDataType] as sdt -- Statistic Data Type
	INNER JOIN dbo.FN_GBL_Reference_GETList(@LangID, 19000090) sdtbr -- Statistic Data Type base reference
	ON sdt.idfsStatisticDataType = sdtbr.idfsReference
	LEFT JOIN dbo.FN_GBL_Reference_GETList(@LangID, 19000076) sdtpt 
	ON sdt.idfsReferenceType = sdtpt.idfsReference
	INNER JOIN dbo.FN_GBL_Reference_GETList(@LangID, 19000091) sptbr -- Statistic Period Type
	ON sdt.idfsStatisticPeriodType = sptbr.idfsReference
	INNER JOIN dbo.FN_GBL_Reference_GETList(@LangID, 19000089) satbr -- Statistic Area Type
	ON sdt.idfsStatisticAreaType = satbr.idfsReference
	WHERE sdt.[intRowStatus] = 0 
	ORDER BY sdtbr.[intOrder], sdtbr.[strDefault];
END TRY
BEGIN CATCH
	THROW
END CATCH
END
