

--##SUMMARY Checks connection between case/session diagnoses and diagnosis/diagnoses group

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 15.08.2013

--##REMARKS UPDATED BY: 
--##REMARKS Date: 

--##RETURNS -1 if @idfsDiagnosisOrDiagnosisGroup is diagnoses group AND one of case diagnoses is contained in this diagnoses group, 
--##RETURNS -2 if @idfsDiagnosisOrDiagnosisGroup is diagnosis AND one of case diagnoses is equal to this diagnosis, 
--##RETURNS ID of case diagnosis if @idfsDiagnosisOrDiagnosisGroup is diagnosis AND one of case diagnoses is contained in the same diagnoses group as input diagnosis, 
--##RETURNS 0 in other case

/*
--Example of function call:
DECLARE @Result bigint
DECLARE @idfCase bigint
DECLARE @idfsDiagnosisOrDiagnosisGroup bigint
set @idfCase=12677020000000
set @idfsDiagnosisOrDiagnosisGroup=12676740000000
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroup(@idfCase, @idfsDiagnosisOrDiagnosisGroup)
SELECT @idfsDiagnosisOrDiagnosisGroup, @Result
set @idfsDiagnosisOrDiagnosisGroup=784230000000
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroup(@idfCase, @idfsDiagnosisOrDiagnosisGroup)
SELECT @idfsDiagnosisOrDiagnosisGroup, @Result
set @idfCase=12680260000000
set @idfsDiagnosisOrDiagnosisGroup=784220000000
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroup(@idfCase, @idfsDiagnosisOrDiagnosisGroup)
SELECT @idfsDiagnosisOrDiagnosisGroup, @Result
set @idfsDiagnosisOrDiagnosisGroup=784790000000
SET @Result = dbo.fnIsCaseSessionDiagnosesInGroup(@idfCase, @idfsDiagnosisOrDiagnosisGroup)
SELECT @idfsDiagnosisOrDiagnosisGroup, @Result
*/

CREATE function [dbo].[fnIsCaseSessionDiagnosesInGroup]	(
						@idfCase bigint,
						@idfsDiagnosisOrDiagnosisGroup bigint)
returns bigint
as
begin

declare @res bigint
set @res = 0

declare @caseDiagnoses table (idfsDiagnosis bigint primary key)
insert into @caseDiagnoses
		--human diagnoses
		select		ISNULL(idfsFinalDiagnosis, idfsTentativeDiagnosis) as idfsDiagnosis
		from		tlbHumanCase
		where		idfHumanCase=@idfCase and COALESCE(idfsFinalDiagnosis, idfsTentativeDiagnosis, -1) <> -1
		union
		-- vet diagnoses
		select		idfsFinalDiagnosis
		from		tlbVetCase		
		where		idfVetCase=@idfCase and idfsFinalDiagnosis is not null
		union
		select		idfsTentativeDiagnosis
		from		tlbVetCase
		where		idfVetCase=@idfCase and idfsTentativeDiagnosis is not null
		union
		select		idfsTentativeDiagnosis1
		from		tlbVetCase
		where		idfVetCase=@idfCase and idfsTentativeDiagnosis1 is not null
		union
		select		idfsTentativeDiagnosis2
		from		tlbVetCase
		where		idfVetCase=@idfCase and idfsTentativeDiagnosis2 is not null
		union
		--VS diagnoses
		Select distinct Test.idfsDiagnosis
		From  dbo.tlbPensideTest Test
		Inner Join dbo.tlbMaterial Material On
		Material.idfMaterial = Test.idfMaterial
		Where Material.idfVectorSurveillanceSession = @idfCase and Test.idfsDiagnosis is not null
		union
		Select distinct Test.idfsDiagnosis
		From  dbo.tlbTesting Test
		Inner Join dbo.tlbMaterial Material On
		Material.idfMaterial = Test.idfMaterial
		Where Material.idfVectorSurveillanceSession = @idfCase
		union
		Select distinct Vssd.[idfsDiagnosis] 
		From  dbo.tlbVectorSurveillanceSessionSummary Vss
		Inner Join dbo.tlbVectorSurveillanceSessionSummaryDiagnosis Vssd On
		Vss.[idfsVSSessionSummary] = Vssd.[idfsVSSessionSummary]
		Where Vss.idfVectorSurveillanceSession = @idfCase


	-- @idfsDiagnosisOrDiagnosisGroup is group
	if exists(
	  select	1
	  from @caseDiagnoses d
	  inner join	trtDiagnosisToDiagnosisGroup gr
	  on			gr.idfsDiagnosis=d.idfsDiagnosis
					and gr.idfsDiagnosisGroup = @idfsDiagnosisOrDiagnosisGroup
					and gr.intRowStatus = 0
	  )
	set @res = -1

	-- @idfsDiagnosisOrDiagnosisGroup is diagnosis
	else if exists(
	  select	1
	  from @caseDiagnoses d
	  where d.idfsDiagnosis = @idfsDiagnosisOrDiagnosisGroup
	  )
	set @res = -2

	else 
	  select	@res = d.idfsDiagnosis
	  from @caseDiagnoses d
	  inner join	trtDiagnosisToDiagnosisGroup grC
	  on			grC.idfsDiagnosis=d.idfsDiagnosis
					and grC.intRowStatus = 0
	  inner join	trtDiagnosisToDiagnosisGroup grD
	  on			grD.idfsDiagnosis=@idfsDiagnosisOrDiagnosisGroup
					and grD.intRowStatus = 0
					and grC.idfsDiagnosisGroup = grD.idfsDiagnosisGroup

	

return @res

end

