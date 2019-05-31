

-- exec spTestForDisease_SelectLookup 'en'

create        PROCEDURE [dbo].[spTestForDisease_SelectLookup]
	@LangID NVARCHAR(50)
AS
	SELECT 
				idfTestForDisease,
				isnull(idfsTestName,0) AS idfsReference,
				idfsDiagnosis,
				idfsTestCategory,
				Names.name,
				Names.intHACode,
				intRowStatus
	FROM		trtTestForDisease
	LEFT JOIN	fnReference(@LangID,19000097) Names --Test Type
	ON			Names.idfsReference=trtTestForDisease.idfsTestName

union all
	SELECT 
				idfsReference as idfTestForDisease,
				idfsReference,
				0 as idfsDiagnosis,
				0 as idfsTestCategory,
				Names.name,
				Names.intHACode,
				intRowStatus
	FROM		fnReferenceRepair(@LangID,19000097) Names--Test Type
order by name
