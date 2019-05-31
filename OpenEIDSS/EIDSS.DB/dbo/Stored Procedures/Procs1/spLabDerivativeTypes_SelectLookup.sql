

/*
	exec spLabDerivativeTypes_SelectLookup 'en'
*/

CREATE PROCEDURE dbo.spLabDerivativeTypes_SelectLookup
	@LangID nvarchar(50)
AS
BEGIN
	select		trtDerivativeForSampleType.idfDerivativeForSampleType,
				trtDerivativeForSampleType.idfsSampleType,
				trtDerivativeForSampleType.idfsDerivativeType,
				Types.name as [name],
				(Types.intRowStatus + trtDerivativeForSampleType.intRowStatus) as intRowStatus
	from		trtDerivativeForSampleType
	left join	fnReferenceRepair(@LangID,19000087) Types
	on			Types.idfsReference=trtDerivativeForSampleType.idfsDerivativeType
	--where		intRowStatus=0
END

