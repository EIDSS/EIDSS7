


--##SUMMARY Selects data for AggregateProphylacticActionMTXDetail form
--##SUMMARY that defines the list of cases and species that should be displayed on AggregateVetCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.12.2009
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

EXECUTE spAggregateProphylacticActionMatrix_SelectDetail 

*/


create       procedure dbo.spAggregateProphylacticActionMatrix_SelectDetail
as
/*
				,@idfsParameterMeasureType3 = 245270000000
				,@idfsParameterMeasureCode3 = 233170000000
				,@idfsParameterSpecies3 = 239050000000
				,@idfsParameterDisease3 = 226950000000
				,@idfsParameterOIECode3	 = 234450000000	
*/
select	 tlbAggrProphylacticActionMTX.idfAggrProphylacticActionMTX
		,isnull(tlbAggrMatrixVersionHeader.idfVersion,0) as idfVersion
		,null as idfSpeciesRow
		,tlbAggrProphylacticActionMTX.idfsSpeciesType as idfsSpeciesType
		,null as idfDiagnosisRow
		,tlbAggrProphylacticActionMTX.idfsDiagnosis as idfsDiagnosis
		,null as idfOIECodeRow
		,trtDiagnosis.strOIECode as strOIECode
		,null as idfActionTypeRow
		,tlbAggrProphylacticActionMTX.idfsProphilacticAction as idfsProphilacticAction
		,null as idfActionCodeRow
		,trtProphilacticAction.strActionCode as strActionCode
		,tlbAggrProphylacticActionMTX.intNumRow
from	tlbAggrProphylacticActionMTX
inner join dbo.tlbAggrMatrixVersionHeader 
on	tlbAggrMatrixVersionHeader.intRowStatus = 0
and tlbAggrMatrixVersionHeader.idfVersion = tlbAggrProphylacticActionMTX.idfVersion
inner join trtDiagnosis 
on 	trtDiagnosis.idfsDiagnosis = tlbAggrProphylacticActionMTX.idfsDiagnosis
inner join trtProphilacticAction 
on 	trtProphilacticAction.idfsProphilacticAction = tlbAggrProphylacticActionMTX.idfsProphilacticAction
	and trtProphilacticAction.intRowStatus = 0
where tlbAggrProphylacticActionMTX.intRowStatus = 0
order by	tlbAggrProphylacticActionMTX.intNumRow


--Current matrix version
--We select latest matrix version as default current version
select top 1
		idfVersion
      ,idfsMatrixType as idfsAggrCaseSection
      ,MatrixName
      ,datStartDate 
      ,blnIsActive
      ,blnIsDefault
from	tlbAggrMatrixVersionHeader
where 	idfsMatrixType = 71300000000 /*ProphilacticAction matrix*/
		and intRowStatus = 0
order by cast(isnull(blnIsDefault,0) as int)+cast(isnull(blnIsActive,0) as int) desc, datStartDate desc

--Lookup list of all available matrix versions
exec spAggregateMatrixVersion_SelectLookup 'en', 71300000000 /*ProphilacticAction matrix*/



