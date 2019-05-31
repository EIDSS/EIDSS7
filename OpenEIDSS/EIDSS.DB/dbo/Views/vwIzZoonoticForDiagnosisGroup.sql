



create view vwIzZoonoticForDiagnosisGroup
as
select
	dg.idfsDiagnosisGroup as idfsDiagnosisOrDiagnosisGroup,
	max(cast(isnull(d.blnZoonotic ,0) as int)) as blnZoonotic
from trtDiagnosisToDiagnosisGroup dg 
	inner join trtDiagnosis d
	on dg.idfsDiagnosis = d.idfsDiagnosis
group by dg.idfsDiagnosisGroup
union
select 
	d.idfsDiagnosis as idfsDiagnosisOrDiagnosisGroup,
	cast(isnull(d.blnZoonotic ,0) as int) as blnZoonotic
from trtDiagnosis d
	



