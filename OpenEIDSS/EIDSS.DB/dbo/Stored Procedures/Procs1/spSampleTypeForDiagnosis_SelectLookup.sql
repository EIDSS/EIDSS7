

-- exec spSampleTypeForDiagnosis_SelectLookup 'en'

create        PROCEDURE [dbo].[spSampleTypeForDiagnosis_SelectLookup]
	@LangID NVARCHAR(50),
	@intHACode int = null
AS
	SELECT 
				idfMaterialForDisease,
				isnull(idfsSampleType,0) AS idfsReference,
				idfsDiagnosis,
				Names.name,
				Names.intHACode,
				intRowStatus
	FROM		trtMaterialForDisease
	LEFT JOIN	fnReference(@LangID,19000087) Names--specimen Type
	ON			Names.idfsReference=trtMaterialForDisease.idfsSampleType
	WHERE
	 (@intHACode = 0 or @intHACode is null or (intHACode & @intHACode)>0)
	 and intRowStatus = 0
union all
	SELECT 
				ROW_NUMBER() OVER(ORDER BY idfsReference DESC) as idfMaterialForDisease,
				idfsReference,
				0 as idfsDiagnosis,
				Names.name,
				Names.intHACode,
				intRowStatus
	FROM		fnReferenceRepair(@LangID,19000087) Names--specimen Type
	WHERE
	 (@intHACode = 0 or @intHACode is null or (intHACode & @intHACode)>0)
order by name
