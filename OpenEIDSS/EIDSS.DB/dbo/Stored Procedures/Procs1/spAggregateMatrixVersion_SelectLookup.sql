


--##SUMMARY Selects lookup list of aggregate matrix versions for specific aggregate matrix Type.
--##SUMMARY Usable matix types are:
--##SUMMARY     VetCase = 71090000000
--##SUMMARY     DiagnosticAction = 71460000000
--##SUMMARY     ProphylacticAction = 71300000000
--##SUMMARY     HumanCase = 71190000000
--##SUMMARY     SanitaryAction = 71260000000


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 9.02.2010
--##REMARKS Update date: 21.05.2013 by Romasheva S.

--##RETURNS Doesn't use


/*
--Example of procedure call:
exec spAggregateMatrixVersion_SelectLookup 'en', NULL
*/

create      procedure dbo.spAggregateMatrixVersion_SelectLookup
	@LangID as nvarchar(50), --##PARAM @LangID - language ID
	@idfMatrix as bigint = NULL  --##PARAM @idfMatrix - aggregate matrix ID

as
if @idfMatrix is null --correct matrixes defaults during loading lookup cache
begin
	exec spAggregateMatrixVersion_CorrectDefault 71090000000
	exec spAggregateMatrixVersion_CorrectDefault 71190000000
	exec spAggregateMatrixVersion_CorrectDefault 71460000000
	exec spAggregateMatrixVersion_CorrectDefault 71300000000
	exec spAggregateMatrixVersion_CorrectDefault 71260000000
end
select idfVersion
      ,idfsMatrixType as idfsAggrCaseSection
      ,MatrixName
      ,datStartDate
      ,blnIsActive
      ,blnIsDefault
	  ,CAST(ISNULL(blnIsDefault,0) AS INT)+CAST(ISNULL(blnIsActive,0) AS INT) AS intState
	  ,intRowStatus
from	tlbAggrMatrixVersionHeader
where (@idfMatrix IS NULL OR idfsMatrixType = @idfMatrix)
order by intState desc, datStartDate desc


