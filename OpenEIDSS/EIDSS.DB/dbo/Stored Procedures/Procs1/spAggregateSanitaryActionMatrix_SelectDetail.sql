


--##SUMMARY Selects data for AggregateSanitaryActionMTXDetail form
--##SUMMARY that defines the list of sanitary actions that should be displayed on VetAggregateActionDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.02.2011
--##REMARKS Update date: 22.05.2013 by Romasheva S.

--##RETURNS Doesn't use



/*
--Example of procedure call:

EXECUTE spAggregateSanitaryActionMatrix_SelectDetail 

*/


create       procedure dbo.spAggregateSanitaryActionMatrix_SelectDetail
as
/*
				,@idfsParameterMeasureType4 = 233190000000
				,@idfsParameterMeasureCode4 = 233150000000
*/
select	 tlbAggrSanitaryActionMTX.idfAggrSanitaryActionMTX as idfSanitaryActionMTX		
		,ISNULL(tlbAggrMatrixVersionHeader.idfVersion,0) AS idfVersion
		,null as idfActionTypeRow
		,trtSanitaryAction.idfsSanitaryAction
		,null as idfActionCodeRow
		,trtSanitaryAction.strActionCode
		,tlbAggrSanitaryActionMTX.intNumRow
from	dbo.tlbAggrSanitaryActionMTX
	inner join trtSanitaryAction
	on trtSanitaryAction.idfsSanitaryAction = tlbAggrSanitaryActionMTX.idfsSanitaryAction
	inner join dbo.tlbAggrMatrixVersionHeader 
	on tlbAggrMatrixVersionHeader.intRowStatus = 0 and
	tlbAggrMatrixVersionHeader.idfVersion = tlbAggrSanitaryActionMTX.idfVersion
where	trtSanitaryAction.intRowStatus = 0
order by
	tlbAggrSanitaryActionMTX.intNumRow
	

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
		idfsMatrixType = 71260000000 /*Sanitary action matrix*/
		and intRowStatus = 0
order by cast(isnull(blnIsDefault,0) as int)+cast(isnull(blnIsActive,0) as int) desc, datStartDate desc

--Lookup list of all available matrix versions
exec spAggregateMatrixVersion_SelectLookup 'en',71260000000 /*Sanitary action matrix*/




