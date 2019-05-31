


--##SUMMARY Selects data for AggregateVetCaseMTXDetail form
--##SUMMARY that defines the list of cases and species that should be displayed on AggregateVetCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.12.2009
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

execute spAggregateVetCaseMatrix_SelectDetail 

*/


create       procedure dbo.spAggregateVetCaseMatrix_SelectDetail
as
/*
@idfsParameterSpecies1 = 239010000000
@idfsParameterDisease1 = 226910000000
@idfsParameterOIECode1 = 234410000000
*/
-- 0 Matix itself with all versions
select	 tlbAggrVetCaseMTX.idfAggrVetCaseMTX
		,tlbAggrMatrixVersionHeader.idfVersion
		,null as idfSpeciesRow 
		,tlbAggrVetCaseMTX.idfsSpeciesType as idfsSpeciesType
		,null as idfDiagnosisRow
		,tlbAggrVetCaseMTX.idfsDiagnosis as idfsDiagnosis
		,null as idfOIECodeRow
		,trtDiagnosis.strOIECode as strOIECode
		,tlbAggrVetCaseMTX.intNumRow
from	tlbAggrVetCaseMTX
	inner join dbo.tlbAggrMatrixVersionHeader 
	on	tlbAggrMatrixVersionHeader.intRowStatus = 0 and
	tlbAggrMatrixVersionHeader.idfVersion = tlbAggrVetCaseMTX.idfVersion
	inner join trtDiagnosis 
	on 	trtDiagnosis.idfsDiagnosis = tlbAggrVetCaseMTX.idfsDiagnosis
where	tlbAggrVetCaseMTX.intRowStatus = 0
order by 	tlbAggrVetCaseMTX.intNumRow

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
where 
		idfsMatrixType = 71090000000 /*VetCase matrix*/
		and intRowStatus = 0
		--and blnIsActive = 1
order by cast(isnull(blnIsDefault,0) as int)+cast(isnull(blnIsActive,0) as int) desc, datStartDate desc

--Lookup list of all available matrix versions
exec spAggregateMatrixVersion_SelectLookup 'en',71090000000 /*VetCase matrix*/


