
--##SUMMARY Returns list of aggregate cases depending on case type that have duplicates.

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 05.11.2013

/*
SELECT * FROM dbo.fnAggregate_FindDuplicates('en', 10102001)
*/

CREATE FUNCTION [dbo].[fnAggregate_FindDuplicates](
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
	,@idfsAggrCaseType as bigint  --##PARAM @idfsAggrCaseType - aggregate case type 
)
RETURNS TABLE 
AS
RETURN

SELECT
	 agr.idfAggrCase
	,DENSE_RANK() OVER (ORDER BY agr.datStartDate, agr.idfsAdministrativeUnit)	AS intDuplicateGroup
	, agr.strCaseID
	, agr.datStartDate
	, agr.strPeriodName
	, agr.strRegion
	, agr.strRayon
	, agr.strSettlement
	, fi.name AS strInstitutionName
	, agr.datEnteredByDate
	
	, CASE WHEN @idfsAggrCaseType = 10102003 /*Vet Aggregate Action*/
			THEN ISNULL(tamvh_diag.MatrixName, '') 
					+ CASE WHEN ISNULL(tamvh_diag.MatrixName, '') <> '' THEN '; ' ELSE '' END
					+ ISNULL(tamvh_prof.MatrixName, '')
					+ CASE WHEN ISNULL(tamvh_prof.MatrixName, '') <> '' THEN '; ' ELSE '' END
					+ ISNULL(tamvh_sanit.MatrixName, '')
		ELSE tamvh_case.MatrixName
	END AS strMatrixName

	, CASE WHEN @idfsAggrCaseType = 10102003 /*Vet Aggregate Action*/
			THEN ISNULL(fr_templ_diag.name, '') 
					+ CASE WHEN ISNULL(fr_templ_diag.name, '') <> '' THEN '; ' ELSE '' END
					+ ISNULL(fr_templ_prof.name, '')
					+ CASE WHEN ISNULL(fr_templ_prof.name, '') <> '' THEN '; ' ELSE '' END
					+ ISNULL(fr_templ_sanit.name, '')
		ELSE fr_templ_case.name
	END AS strTemplateName
FROM dbo.fnAggregateCaseList(@LangId, @idfsAggrCaseType) agr
LEFT JOIN dbo.fnInstitution(@LangId) fi ON
	fi.idfOffice = agr.idfEnteredByOffice
	
JOIN tlbAggrCase tac ON
	tac.idfAggrCase = agr.idfAggrCase
LEFT JOIN tlbAggrMatrixVersionHeader tamvh_diag ON
	tamvh_diag.idfVersion = tac.idfDiagnosticVersion
	AND tamvh_diag.intRowStatus = 0
LEFT JOIN tlbAggrMatrixVersionHeader tamvh_prof ON
	tamvh_prof.idfVersion = tac.idfProphylacticVersion
	AND tamvh_prof.intRowStatus = 0
LEFT JOIN tlbAggrMatrixVersionHeader tamvh_sanit ON
	tamvh_sanit.idfVersion = tac.idfSanitaryObservation
	AND tamvh_sanit.intRowStatus = 0
LEFT JOIN tlbAggrMatrixVersionHeader tamvh_case ON
	tamvh_case.idfVersion = tac.idfVersion
	AND tamvh_case.intRowStatus = 0

LEFT JOIN dbo.fnReference(@LangId, 19000033) fr_templ_diag ON
	fr_templ_diag.idfsReference = agr.idfsDiagnosticFormTemplate
LEFT JOIN dbo.fnReference(@LangId, 19000033) fr_templ_prof ON
	fr_templ_prof.idfsReference = agr.idfsProphylacticFormTemplate
LEFT JOIN dbo.fnReference(@LangId, 19000033) fr_templ_sanit ON
	fr_templ_sanit.idfsReference = agr.idfsSanitaryFormTemplate
LEFT JOIN dbo.fnReference(@LangId, 19000033) fr_templ_case ON
	fr_templ_case.idfsReference = agr.idfsCaseFormTemplate
	
WHERE EXISTS (
				SELECT 
					*
				FROM dbo.fnAggregateCaseList(@LangId, @idfsAggrCaseType) agr2
				WHERE agr2.idfAggrCase <> agr.idfAggrCase
					AND agr2.idfsAggrCaseType = agr.idfsAggrCaseType
					AND agr2.idfsAdministrativeUnit = agr.idfsAdministrativeUnit
					AND agr2.datStartDate = agr.datStartDate
					AND agr2.datFinishDate = agr.datFinishDate
			)
