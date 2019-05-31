

CREATE PROCEDURE [dbo].[spLabTestAssign_SelectList] 
	@LangID nvarchar(50),
	@HACode integer
AS
BEGIN

	select 
		ref.idfsReference,
		name as TestName,
		cast(10095003 as bigint) as idfsTestCategory --tdtPresumptive
	from		fnReference(@LangID,19000097) ref --rftTestName
	where		(ref.intHACode is NULL or @HACode is NULL or ((ref.intHACode & ~1 & @HACode) <> 0))

	select 
		trtTestForDisease.idfTestForDisease,	
		ref.idfsReference,
		ref.name as TestName, 
		trtTestForDisease.idfsTestCategory,
		trtTestForDisease.idfsDiagnosis
	from		fnReference(@LangID,19000097) ref --rftTestName
	--on			ref.idfsReference=Test_Type.idfsTest_Type
	inner join	trtTestForDisease
	on			trtTestForDisease.idfsTestName=ref.idfsReference and trtTestForDisease.intRowStatus = 0
	where		/*ISNULL(Test_Type.blnPensideTest,0)<>1
	and			*/(ref.intHACode is NULL or ((ref.intHACode & @HACode) = @HACode))

END



