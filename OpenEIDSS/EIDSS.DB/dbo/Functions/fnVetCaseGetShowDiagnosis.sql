﻿


/*
	select dbo.fnVetCaseGetShowDiagnosis(1,2,3,null, '2010-01-01', '2011-01-01', '2010-01-01', null)
*/

CREATE function [dbo].[fnVetCaseGetShowDiagnosis]
(
	@idfsTentativeDiagnosis bigint,
	@idfsTentativeDiagnosis1 bigint,
	@idfsTentativeDiagnosis2 bigint,
	@idfsFinalDiagnosis bigint,
	@datTentativeDiagnosisDate datetime,
	@datTentativeDiagnosis1Date datetime,
	@datTentativeDiagnosis2Date datetime,
	@datFinalDiagnosisDate datetime
)
returns bigint
as
begin

	Declare @ret bigint
	Declare @tbl Table ( Number int, Diagnosis bigint, DiagnosisDate datetime )
	Insert Into @tbl Select 1, @idfsFinalDiagnosis, DATEADD(year, 100, @datFinalDiagnosisDate)
	Insert Into @tbl Select 2, @idfsTentativeDiagnosis2, @datTentativeDiagnosis2Date
	Insert Into @tbl Select 3, @idfsTentativeDiagnosis1, @datTentativeDiagnosis1Date
	Insert Into @tbl Select 4, @idfsTentativeDiagnosis, @datTentativeDiagnosisDate

	Select top 1 @ret = Diagnosis
	From @tbl
	Where Diagnosis is not null
	Order by DiagnosisDate desc, Number

	Return @ret

end








