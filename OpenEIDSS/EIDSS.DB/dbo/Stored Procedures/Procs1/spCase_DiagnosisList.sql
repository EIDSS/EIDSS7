

--##SUMMARY Get list of diagnoses associated with case or sessions.
--##SUMMARY It is assumed that if @idfCase = 0 the diagnosis for vector surveillance session should be returned
--##SUMMARY Vector surveillance session should contain the list of all diagnosis marked with Vector HAcode.
--##SUMMARY In other case diagnosis related with case or monitoring session should be returned
--##REMARKS Author: Kletkin.
--##REMARKS Update date: 28.04.2010

--##RETURNS Case and Diagnosis and Diagnosis title


CREATE PROCEDURE [dbo].[spCase_DiagnosisList]
	@idfCase bigint,
	@LangID nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--select	* from dbo.fnCase_DiagnosisList(@idfCase, @LangID)
	select 
		d.idfsDiagnosis as idfsReference,
		d.*,
		CAST(CASE WHEN vc.idfsFinalDiagnosis = d.idfsDiagnosis then 1 else 0 end as bit) as blnFinalDiagnosis
	from fnCase_DiagnosisList(@idfCase, @LangID) d
	left join tlbVetCase vc on vc.idfVetCase = @idfCase
	order by blnFinalDiagnosis desc, name asc
END


