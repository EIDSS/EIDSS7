

/*
	exec spLabDerivativeTypes 'en'
*/

CREATE PROCEDURE dbo.spLabDerivativeTypes
	@LangID nvarchar(50)
AS
BEGIN
	select		trtDerivativeForSampleType.idfDerivativeForSampleType,
				trtDerivativeForSampleType.idfsSampleType,
				trtDerivativeForSampleType.idfsDerivativeType,
				Types.name as [name]
	from		trtDerivativeForSampleType
	left join	fnReference_Full(@LangID)Types
	on			Types.idfsReference=trtDerivativeForSampleType.idfsDerivativeType
	where		intRowStatus=0
END

