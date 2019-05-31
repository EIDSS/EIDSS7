


--##SUMMARY Selects data for AggregateDiagnosticActionMTXDetail form
--##SUMMARY that defines the list of diagnostic actions and species that should be displayed on VetAggregateActionDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.12.2009
--##REMARKS Update date: 21.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

EXECUTE spAggregateDiagnosticActionMatrix_SelectDetail 

*/


create       procedure dbo.spAggregateDiagnosticActionMatrix_SelectDetail
as
/*
				,@idfsParameterInvestigationType2 = 231670000000
				,@idfsParameterSpecies2 = 239030000000
				,@idfsParameterDisease2 = 226930000000
				,@idfsParameterOIECode2 = 234430000000
				
*/
SELECT	 tlbAggrDiagnosticActionMTX.idfAggrDiagnosticActionMTX
		,ISNULL(tlbAggrMatrixVersionHeader.idfVersion,0) AS idfVersion
		,null as idfSpeciesRow	-- don't use now
		,tlbAggrDiagnosticActionMTX.idfsSpeciesType  AS idfsSpeciesType
		,null as idfDiagnosisRow	-- don't use now
		,tlbAggrDiagnosticActionMTX.idfsDiagnosis AS idfsDiagnosis
		,null as idfOIECodeRow	-- don't use now
		,trtDiagnosis.strOIECode  AS strOIECode
		,null as idfDiagnosticActionRow	-- don't use now
		,tlbAggrDiagnosticActionMTX.idfsDiagnosticAction AS idfsDiagnosticAction
		,tlbAggrDiagnosticActionMTX.intNumRow
		
FROM	tlbAggrDiagnosticActionMTX
INNER JOIN dbo.tlbAggrMatrixVersionHeader ON
	tlbAggrMatrixVersionHeader.idfVersion = tlbAggrDiagnosticActionMTX.idfVersion and 
	tlbAggrMatrixVersionHeader.intRowStatus = 0
INNER JOIN trtDiagnosis ON 
	trtDiagnosis.idfsDiagnosis = tlbAggrDiagnosticActionMTX.idfsDiagnosis
WHERE
		tlbAggrDiagnosticActionMTX.intRowStatus = 0
Order By
	tlbAggrDiagnosticActionMTX.intNumRow
	

--Current matrix version
--We select latest matrix version as default current version
SELECT TOP 1
		idfVersion
      ,idfsMatrixType as idfsAggrCaseSection
      ,MatrixName
      ,datStartDate 
      ,blnIsActive
      ,blnIsDefault
FROM	tlbAggrMatrixVersionHeader
WHERE 
		idfsMatrixType = 71460000000 /*Diagnostic matrix*/
		and intRowStatus = 0
ORDER BY CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) DESC, datStartDate DESC

--Lookup list of all available matrix versions
EXEC spAggregateMatrixVersion_SelectLookup 'en',71460000000 /*Diagnostic matrix*/




