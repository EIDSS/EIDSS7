


--##SUMMARY Selects data for AggregateHumanCaseMTXDetail form
--##SUMMARY that defines the list of diagnosis that should be displayed on AggregateCaseDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.02.2011

--##RETURNS Doesn't use

--##REMARKS Update date: 21.05.2013 by Romasheva S.

/*
--Example of procedure call:

EXECUTE spAggregateHumanCaseMatrix_SelectDetail 

*/


create       procedure dbo.spAggregateHumanCaseMatrix_SelectDetail
as
/*
				@idfsParameterDiagnosis0 = 226890000000
				,@idfsParameterICD10Code0 = 229630000000
*/
select	 
		mtx.idfAggrHumanCaseMTX as idfHumanCaseMtx
		,isnull(amvh.idfVersion,0) as idfVersion
		,null as idfDiagnosisRow -- don't use now
		,null as idfIDCCodeRow -- don't use now
		,mtx.idfsDiagnosis
		,d.strIDC10
		,mtx.intNumRow
from	tlbAggrHumanCaseMTX mtx
	inner join trtDiagnosis d
	on d.idfsDiagnosis = mtx.idfsDiagnosis
	inner join dbo.tlbAggrMatrixVersionHeader  amvh
	on	amvh.intRowStatus = 0 and amvh.idfVersion = mtx.idfVersion
order by mtx.intNumRow
	

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
		idfsMatrixType = 71190000000 /*Human case matrix*/
		and intRowStatus = 0
order by cast(isnull(blnIsDefault,0) as int)+cast(isnull(blnIsActive,0) as int) desc, datStartDate desc

--Lookup list of all available matrix versions
exec spAggregateMatrixVersion_SelectLookup 'en',71190000000 /*Human case matrix*/




